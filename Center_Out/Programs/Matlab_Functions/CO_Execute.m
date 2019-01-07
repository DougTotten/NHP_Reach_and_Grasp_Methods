function [t_initiate,t_contact,t_release,t_trial_start,t_trial_end]=CO_Execute (handles,active_light,hold_time,trial_time,punish_time,play_ding,start_time, trial_number,mots_on)
global s_cap stop_script s_cam

%% optional control
use_ard_camtrig=0; % set to 1 if using arduino to control camera triggers

%% Turn on the light for the active window
fprintf ('\n------------------\nActive light: %.0f\n',active_light);
on_lights=zeros(1,9);
on_lights (active_light)=1;
CO_Lights(s_cap,on_lights);

%%% Give time to load if this is automated
if mots_on
    load_time=str2num(get(handles.load_time,'String'));
    pause(load_time)
end


%% Play unique trial identifier
if use_ard_camtrig
    Arduino_Trigger_Control (s_cam,1)
end
CO_Trial_Code (s_cap,trial_number)
pause (0.5)
if use_ard_camtrig
    Arduino_Trigger_Control (s_cam,0)
end

%% Wait for successful hold

released_early=1;
start_cams=1;
while released_early==1
    
    track_time(start_time,handles);
    drawnow
    
    if stop_script
       break 
    end
        
    % Give trial-start cue
    on_lights=zeros(1,9);
    on_lights(9)=1;
    on_lights(active_light)=1;
    CO_Lights(s_cap,on_lights);
    
    t_initiate=toc(start_time);
    
    % Wait for touch-sensor activation
    fprintf ('\nWaiting for touch-sensor activation')
    touched_0=0;
    while ~touched_0
        track_time(start_time,handles);
        drawnow
        if stop_script
            break
        end
        touched_0=Read_MPR121_CO(s_cap);
    end
    if stop_script
       break 
    end
    fprintf ('\nSensor touched')
    t_contact=toc(start_time);
    
    %%% Start Cams
    if start_cams
        %% Start camera trigger
        if use_ard_camtrig
            Arduino_Trigger_Control (s_cam,1)
        end
        start_cams=0;
    end
    
    
    % Hold touch sensor
    release_sensitivity=.01; % time in seconds before registering a capacitor release
    released_early=0;
    fprintf ('\nHolding sensor')
    hold_start=tic;
    fprintf('\nStarting hold-cue loop')
    while toc(hold_start)<hold_time
        
        track_time(start_time,handles);
        drawnow
    
        touched_0=Read_MPR121_CO(s_cap);
        
        if ~touched_0
            release_start=tic;
            while ~touched_0
                touched_0=Read_MPR121_CO(s_cap);
                if toc(release_start)>release_sensitivity
                    released_early=1;
                    
                    on_lights=zeros(1,9);
                    on_lights(active_light)=1;
                    CO_Lights(s_cap,on_lights);
                    break
                end
            end
        end
        if released_early
            
            punish_start=tic; 
            
            while toc(punish_start)<punish_time
                track_time(start_time,handles);
                drawnow
            end
                        
            break % end this round of the while loop
        end
        
    end
    t_release=toc(start_time);
end

if stop_script
    t_initiate=nan;
    t_contact=nan;
    t_release=nan;
    t_trial_start=nan;
    t_trial_end=nan;
    
    on_lights=zeros(1,9);
    CO_Lights(s_cap,on_lights);

    fprintf ('\nStopping video acquisition')
    if use_ard_camtrig
        Arduino_Trigger_Control(s_cam,0)
    end
    
    return
end

%% Once hold has been successfully completed
on_lights=zeros(1,9);
on_lights(active_light)=1;
CO_Lights(s_cap,on_lights);

play (play_ding)

if mots_on
    CO_Position_Blocker(1)
end

t_trial_start=toc(start_time);

set(handles.success_count,'String',num2str( str2num(get(handles.success_count,'String')) + 1) );

% Wait for trial time to elapse
trial_start=tic;
while toc(trial_start)<trial_time
    track_time(start_time,handles);
    drawnow
end
t_trial_end=toc(start_time);

if mots_on
    CO_Position_Blocker(0)
end


fprintf ('\nStopping video acquisition')
if use_ard_camtrig
    Arduino_Trigger_Control(s_cam,0)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function track_time (start_time,handles)
% % time_now=double(tic);
% time_lapsed=(time_now-double(start_time))/1000000;
time_lapsed=toc(start_time);
mins=floor(time_lapsed/60);
secs10=floor((time_lapsed-mins*60)/10);
secs1=floor(time_lapsed-mins*60-secs10*10);
tl_txt=sprintf ('%i:%i%i ',mins,secs10,secs1);
set(handles.time_txt,'String',tl_txt);
