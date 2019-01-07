function R2G_Wrap (handles)

% This is the main script for running the NHP reach to grasp experiments

% CONNECT HARDWARE
% cameras
% capacitive touch sensor
% motor
% leap motion
% IMUs
%
% SETUP TASK STRUCTURE
% Number of blocks
% Trial orders per block
% Data structures
% Once you accumate some controllable parameters you could build a GUI to
% make it easier. These would include number of trials, time-out
% punishments, hold-time on capacitive sensor, trial termination point
%
% RUNNING THE TASK:
% Send hold-cue
% Read from capacitive sensor
% Send go-cue or termination-cue depending on whether trigger was held long
% enough
% pre-trial criteria: Press capacitive touch sensor, load pellet, if sensor
% released early, clear pellet
% cue trial start

% Arduino needs to have sketch TB6600_Driver_and_Lights_Matlab loaded.

%% Global Params

global s_cap s_mot s_cam well_a_position play_ding stop_script adjust_well
% s_cap: serial connection for reading the capacitive touch sensor
% s_mot: serial connection for running motor

%% Optional Controls
use_ard_camtrig=0; % Change to 1 if using arduino to control camera triggers
% Also change in R2G_Execute_Behavior.m 

%% Initialize Hardware
fprintf ('\nBuilding Data Storage Directory')
[store_path]=R2G_Initialize_Storage (get(handles.monk_name,'String'));

fprintf ('\nInitializing Arduino Stepper...\n')
Initialize_Arduino_TB6600_Stepper('COM3');

fprintf ('\nInitializing Capasitive Sensor...\n')
R2G_Initialize_Arduino_CapSense ('COM4');

if use_ard_camtrig
    fprintf ('\nInitializing Arduino Trigger...\n')
    Initialize_Arduino_Cameras ('COM6');
end

try
    
    fprintf ('\nLoading Sounds')
    load sound_ding.mat
    
    play_ding=audioplayer(ding_snd,ding_fs);

    %% Task Structure
    
    if nargin>0
        
        n_reps=str2num(get(handles.n_reps,'String'));
        hold_min=str2num(get(handles.hold_min,'String'));
        hold_max=str2num(get(handles.hold_max,'String'));
        trial_time=str2num(get(handles.trial_time,'String'));
        punish_time=str2num(get(handles.punish_time,'String'));
        
        w37=get(handles.w37,'Value');
        w31=get(handles.w31,'Value');
        w25=get(handles.w25,'Value');
        w19=get(handles.w19,'Value');
        w13=get(handles.w13,'Value');
        w10=get(handles.w10,'Value');
        
%         active_wells=[w37 w31 w25 w19 w13 w10];
        active_wells=[w10 w13 w19 w25 w31 w37];
        
        monk_name=get (handles.monk_name,'String');
        
        man_pel=get(handles.man_pel,'Value');
                
    else
        n_reps=3;
        
        hold_min=1;
        hold_max=2;
        
        trial_time=5; % 30 seconds
        punish_time=5; % seconds
        
        active_wells=[1 0 0 0 0 0];
        
        man_pel=0;
    end
    
    % Set number of trials
    % well_diams=[31 25 19 13 10 0]; % 0 is the condition that isn't a well
    % well_diams=[10 0]; % 0 is the condition that isn't a well
%     all_wells=[37 31 25 19 13 10];
    all_wells=[10 13 19 25 31 37];
    use_wells=find (active_wells==1); % 0 is the condition that isn't a well
    n_wells=length(use_wells);
    n_trials=n_wells*n_reps;
    well_order=nan(n_reps,n_wells);
    
    stim_trials=nan(n_reps,n_wells);
    
    % Set trial order
    for i=1:n_reps;
        well_order(i,:)=randperm(n_wells);
    end
    
    % Set hold time
    hold_diff=hold_max-hold_min;
    hold_times=hold_min+hold_diff*rand(n_reps,n_wells);
    
    save_params={'all_wells','active_wells','n_wells','n_reps','n_trials','well_order','hold_min','hold_max','hold_times','trial_time','punish_time','monk_name','stim_trials','stim_reps'};
    save(strcat(store_path,'\parameters'),save_params{:});
    
    %% Run Block
    start_fig=msgbox ('Position smallest well at the pellet dispensor, then press "OK"');
    waitfor (start_fig)
    
    well_a_position=0;
    
    if ~man_pel
    start_fig2=msgbox ('Spin pellet dispenser so that the next slots have pellets loaded');
        active_well=6;
        move_time=R2G_Position_Wells (active_well,1);
        waitfor (start_fig2)

        [move_time]=R2G_Position_Wells (active_well,4); % dump pellet if they haven't retrieved it
        
    end
    
    start_time=tic;
    set(handles.win_txt,'String','0');
    
    all_times=get(handles.man_pel_time,'String');
    man_pel_time=str2num(all_times{get(handles.man_pel_time,'Value')});
    
    trial_counter=0;
    
    t_initiate=nan(n_reps,n_wells);
    t_contact=nan(n_reps,n_wells);
    t_release=nan(n_reps,n_wells);
    t_trial_start=nan(n_reps,n_wells);
    t_trial_end=nan(n_reps,n_wells);
    
    adjust_well=0;
    for i=1:n_reps
        j=1;
        while j<=n_wells
            trial_counter=trial_counter+1;
            
            active_well=use_wells(well_order(i,j));
            
            trial_name=sprintf ('Rep%s_Trial%s_Well%s',num2str(i),num2str(j),num2str(active_well));
            
            if ~man_pel
                R2G_Load_Pellet (active_well);
            else
                move_time=R2G_Position_Wells (active_well,5);         
                
                for k=1:man_pel_time*2
                    R2G_Lights(s_cap, [0 0 0 0 0 1]);
                    pause (.25);
                    R2G_Lights(s_cap, [0]);
                    pause (.25);
                    Track_Time(start_time,handles);
                end
                R2G_Lights(s_cap,[0]);
            end
            
           [t_initiate(i,j),t_contact(i,j),t_release(i,j),t_trial_start(i,j),t_trial_end(i,j)]= R2G_Execute_Behavior (active_well,hold_times(i,j),trial_time,punish_time,trial_name,handles,start_time,trial_counter);
            
            if stop_script
               break 
            end
            
            if adjust_well
                
                fprintf(s_mot,'3\n0'); % release motor
                motor_release_txt=fscanf(s_mot);
                
                h_adj=msgbox('Position smallest well below pellet dispensor');
                waitfor (h_adj)
                
                j=j-1; % this will make the loop run again
                adjust_well=0;
                well_a_position=0;
                
            end
            
            j=j+1;
        end
        if stop_script
            break
        end
    end
    
    active_well=6;
    move_time=R2G_Position_Wells (active_well,1); % move smallest well to pellet load position
    
%     fprintf ('\nFinishing video acquision')
%     for i=1:length(cam_cell)
%         stop(cam_cell{i})
%     end
%     fprintf('\nFinished\n')
    
    save(strcat(store_path,'\workspace'));
    
    fprintf(s_mot,'3\n0'); %disengage the motor
    disengage_motor_txt=fscanf(s_mot);
    
    fprintf ('\n\n---- closing serial connection ---------\n')
    fclose(s_mot);                 % always, always want to close s_mot
    fclose(s_cap);                 % always, always want to close s_cap
    
    if use_ard_camtrig
        fclose (s_cam);
    end
    
    imaqreset
    
catch exception
    
    imaqreset
    
    fprintf ('\n')
    disp(getReport(exception,'extended')) 
    
    save(strcat(store_path,'\workspace_ERROR'));
    
    active_well=6;
    move_time=R2G_Position_Wells (active_well,1); % move smallest well to pellet load position
    
    fprintf(s_mot,'3\n0');
    disengage_motor_txt=fscanf(s_mot);
    
    fprintf ('\n\n---- closing serial connection ---------\n')
    fclose(s_mot);                 % always, always want to close s_mot
    fclose(s_cap);                 % always, always want to close s_cap
    if use_ard_camtrig
        fclose (s_cam);
    end
end





