   function CO_Wrap (handles)
% This is the wrapper for the center-out reaching task. It gets called by
% the GUI, CO_Interface.m

%%% TO DO: Save time stamps for when the buttons are pressed. There is
%%% definitely lag between the button press and when the lights react;
%%% figure out why that is and make sure it isn't hurting our resolution
%%% for button contact  

% Initialize the arduino
% Initialize the cameras
% Initialize data storage
% Setup the task

global s_cap stop_script is_open s_mot s_cam

%% Optional Controls
use_ard_camtrig=0; % change to 1 if using an arduino to control camera triggers
% also change in CO_Execute

%% Initialize Hardware

fprintf ('\nBuilding Data Storage Directory')
[store_path]=Initialize_Storage (get(handles.monk_name,'String'),'Center Out');

fprintf ('\nInitializing Capasitive Sensor...\n')
CO_Initialize_Arduino_CapSense ('COM8');

if use_ard_camtrig
    fprintf ('\nInitializing Arduino Trigger...\n')
    Initialize_Arduino_Cameras ('COM6');
end

mots_on=get(handles.mots_on,'Value');
if mots_on
    fprintf ('\nInitializing Arduino Stepper...\n')
    Initialize_Arduino_TB6600_Stepper('COM7');
end

try % If there is an error at any point, close the serial connection
    
    fprintf ('\nLoading Sounds')
    load sound_ding.mat
    load sound_buzz.mat
    
%     play_ding=audioplayer(ding_snd,36000);
    play_ding=audioplayer(ding_snd,ding_fs);
    play_buzz=audioplayer(buzz_snd,buzz_fs);
    
    snds.buzz_snd=buzz_snd;
    snds.buzz_fs=buzz_fs;
    snds.ding_snd=ding_snd;
    snds.ding_fs=ding_fs;
    
    %% Load inputs from GUI
    if nargin>0
        
        n_reps=str2num(get(handles.n_reps,'String'));
        hold_min=str2num(get(handles.hold_min,'String'));
        hold_max=str2num(get(handles.hold_max,'String'));
        trial_time=str2num(get(handles.trial_time,'String'));
        punish_time=str2num(get(handles.punish_time,'String'));
        
        monk_name=get(handles.monk_name,'String');
        
        stim_on=get(handles.stim_on,'Value');
        
        if stim_on
            % Get stim values
            pre_stim=str2num(get(handles.pre_block,'String'));
            n_stim=str2num(get(handles.stim_block,'String'));
            post_stim=str2num(get(handles.post_block,'String'));
            
            if get(handles.stim_first,'Value')
                stim_reps=[ones(n_stim,1);zeros(post_stim,1)];
            else
                stim_reps=[zeros(post_stim,1);ones(n_stim,1)];
            end
        else
            stim_reps=zeros(n_reps,1);
        end
        
    else
        n_reps=2;
        
        hold_min=1;
        hold_max=2;
        
        trial_time=5; % 30 seconds
        punish_time=5; % seconds
        
        active_wells=[1 0 0 0 0 0];
        
        monk_name='no interface';
    end
    
    
    
    %% Task Structure
    
    %%%% Light Assignment: 1 is at 3oclock, then proceed clockwise
%           1
%             
%     4           2
%              
%           3

% ready = 9
    
    % Which lights are active
    active_lights=[1 2 3 4]; % top, right, bottom, left
    n_lights=length(active_lights);
    n_trials=n_lights*n_reps;
    light_order=nan(n_reps,n_lights);
    
    % Set trial order
    for i=1:n_reps
        light_order(i,:)=randperm(n_lights);
    end
    
    % Set hold time
    hold_diff=hold_max-hold_min;
    hold_times=hold_min+hold_diff*rand(n_reps,n_lights);
    
    % Save all the parameters
    save_params={'active_lights','n_lights','n_reps','n_trials','light_order','hold_min','hold_max','hold_times','trial_time','punish_time','monk_name','stim_reps'};
    save(strcat(store_path,'\parameters'),save_params{:});
    
    %% Set blocker into position
    if mots_on
        startbox=msgbox('Position the blocker so that the windows are all open');
        fprintf(s_mot,'3\n0\n');
        waitfor(startbox);
        is_open=1;
        h=CO_Blocker_Adjust;
        waitfor (h)
        
        CO_Position_Blocker(0);
        pause (.5);
        CO_Position_Blocker(1);
        pause (.5);
        CO_Position_Blocker(0);
    end
    
    %% Run Block
    
    full_start_time=tic;
    set(handles.success_count,'String','0');
    t_initiate=nan(n_reps,n_lights);
    t_contact=nan(n_reps,n_lights);
    t_release=nan(n_reps,n_lights);
    t_trial_start=nan(n_reps,n_lights);
    t_trial_end=nan(n_reps,n_lights);
    
    trial_number=0;
    for i=1:n_reps
        
        for j=1:n_lights
            trial_number=trial_number+1;
            this_light=active_lights(light_order(i,j));
            
            [t_initiate(i,j),t_contact(i,j),t_release(i,j),t_trial_start(i,j),t_trial_end(i,j)]=CO_Execute (handles,this_light,hold_times(i,j),trial_time,punish_time,play_ding,full_start_time,trial_number,mots_on);
            
            if stop_script
                break
            end
            
        end
        
        if stop_script
            break
        end
        
    end
    
    if use_ard_camtrig
        fclose (s_cam)
    end
    
    save(strcat(store_path,'\workspace'));
    
    on_lights=zeros(1,9);
    CO_Lights(s_cap,on_lights);

    fprintf ('\n---- closing serial connection ---------\n')
    fclose(s_cap);                 % always, always want to close s_cap
    if mots_on
        CO_Position_Blocker(1)
        fclose (s_mot);
    end
    
    imaqreset % disengage cameras so they don't bog the CPU
    
catch exception
    
    save(strcat(store_path,'\workspace_ERROR'));
    
    if use_ard_camtrig
        fclose (s_cam);
    end
    
    on_lights=zeros(1,9);
    CO_Lights(s_cap,on_lights);
    
    imaqreset
    
    disp(getReport(exception,'extended'))
    fprintf ('\n---- closing serial connection ---------\n')
    fclose(s_cap);                 % always, always want to close s_cap
    if mots_on
        CO_Position_Blocker(1)
        fclose (s_mot);
    end
end

