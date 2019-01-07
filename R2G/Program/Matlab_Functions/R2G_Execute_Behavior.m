function [t_initiate,t_contact,t_release,t_trial_start,t_trial_end]=R2G_Execute_Behavior (active_well,hold_time,trial_time,punish_time,trial_name,handles,start_time,trial_number)
% This function runs each trial of the reach-to-grasp task. The pellet gets
% loaded in the wrapper. Here the pellet gets moved so it is almost
% accessible to the monkey and then stays there until the monkey
% successsfully touches and holds the initiation button for the required
% amount of time. If they don't hold for the required amount of time, there
% is a brief time-out and then they have another opportunity to touch and
% hold. The block will not progress until they hold for long enough. Once
% they touch and hold long enough, the well moves into reach. It stays
% within reach for the desired time, then clears the pellet. 

% Video log files are initiated before the lights turn on around the cap
% sensor and the trial is active. Once the monkey makes contact with the
% sensor, the videos begin saving data to buffer. If they release early,
% the log file is closed, data is saved or dumped (haven't decided which)
% and a new log file is started. 

global s_mot s_cap play_ding stop_script s_cam adjust_well

%% Optional Control
use_ard_camtrig=0;


%% Move pellet into ready position
fprintf ('\nActive well: %.0f',active_well);

[move_time]=R2G_Position_Wells (active_well,2);
move_start=tic; % start keeping track of how long it has been since motor started spinning


%% Play unique trial identifier


if use_ard_camtrig
    Arduino_Trigger_Control (s_cam,1)
end
R2G_Trial_Code (s_cap,trial_number)
pause (.5)
if use_ard_camtrig
    Arduino_Trigger_Control (s_cam,0)
end

%% Wait for successful hold
released_early=1;
start_cam=1;
while released_early==1
    
    Track_Time(start_time,handles);
    drawnow
    
    if stop_script | adjust_well
       break 
    end
    
    % Give trial-start cue
    R2G_Lights(s_cap, [1 1 0 0 0]);
    
    t_initiate=toc(start_time);
    
    % Wait for touch-sensor activation
    fprintf ('\nWaiting for touch-sensor activation')
    touched_0=0;
    while ~touched_0
        Track_Time(start_time,handles);
        drawnow
        if stop_script | adjust_well
            break
        end
        touched_0=Read_CapSense(s_cap);
    end

    t_contact=toc(start_time);
    if stop_script | adjust_well
       break 
    end
    tic
    fprintf ('\nSensor touched')
    
    if start_cam
        %% Start camera trigger
        tic_cam=tic;
        if use_ard_camtrig
            Arduino_Trigger_Control (s_cam,1)
        end
        start_cam=0;
        fprintf ('\nTook %.4i sec to start cam',toc(tic_cam))
    end
    
    % Hold touch sensor
    release_sensitivity=.01; % time in seconds before registering a capacitor release
    released_early=0;
    fprintf ('\nHolding sensor')
    tic
    fprintf('\nStarting hold-cue loop')
    while toc<hold_time
        
        Track_Time(start_time,handles);
        drawnow
        
        touched_0=Read_CapSense(s_cap);
        
        if ~touched_0
            release_start=toc;
            while ~touched_0
                touched_0=Read_CapSense(s_cap);
                timenow=toc;
                if (timenow-release_start)>release_sensitivity
                    released_early=1;
                    R2G_Lights(s_cap, [0 0 0 0 1]); % a single yellow blink is the note for a failed hold
                    break
                end
            end
        end
        if released_early
            
            tic % keep track of how long monkey has been on time out
            
            while toc<punish_time
                Track_Time(start_time,handles);
                drawnow
            end
            
            break % end this round of the while loop
        end
        
    end
    t_release=toc(start_time);
end
t_hold_done=tic;

if stop_script
    R2G_Lights(s_cap, [0 0 0 0 0]);
    [move_time]=R2G_Position_Wells (active_well,4); % dump pellet if they haven't retrieved it
    fprintf ('\nStopping video acquisition')
    if use_ard_camtrig
        Arduino_Trigger_Control(s_cam,0)
    end
    
    return
end

if adjust_well
    fprintf ('\nAdjusting well position')
    if use_ard_camtrig
        Arduino_Trigger_Control(s_cam,0)
    end
    t_initiate=nan;
    t_contact=nan;
    t_release=nan;
    t_trial_start=nan;
    t_trial_end=nan;
    return
end

%% Pellet retrieval after succesful hold

% After hold time, move pellet to reach position and give go-cue
trial_start=tic;
play (play_ding)
R2G_Lights(s_cap, [0 0 0 0 0]);

% Move pellet into active position
n_success=str2num(get(handles.win_txt,'String'))+1;
set(handles.win_txt,'String',num2str(n_success));
drawnow

% fprintf('\nTook %.2f from hold-finished to starting to move wells\n',toc(t_hold_done))
[move_time]=R2G_Position_Wells (active_well,3);
% pause(move_time) % Do not need to pause for the move time ...
% R2G_Position_Wells waits for a serial output from arduino before
% continuing

t_trial_start=toc(start_time);

% Wait for trial time to elapse
while toc(trial_start)<trial_time
    Track_Time(start_time,handles);
    drawnow
end

% Arduino_Trigger_Control(s_cam,4) %set MCS-gate to "LOW"

t_trial_end=toc(start_time);

[move_time]=R2G_Position_Wells (active_well,4); % dump pellet if they haven't retrieved it
% pause(move_time) % Do not need to pause for the move time ...
% R2G_Position_Wells waits for a serial output from arduino before
% continuing


% Stop video acquisition
fprintf ('\nStopping video acquisition')
if use_ard_camtrig
    Arduino_Trigger_Control(s_cam,0)
end

end

function touched_0=Read_CapSense(s_cap)
% flushinput(s_cap) % for some reason I need to flush the input to only get the most recent reading
% tic
fprintf(s_cap,'2/n0') % send a 2 and then any number
% fprintf ('\nSending serial output took %.4f seconds', toc)
% returned=fscanf(s_cap);
% tic
bin_value=str2num(fscanf(s_cap));
touched_0=0;
% fprintf ('\nRetrieving sensor reading took %.4f seconds', toc)

if bin_value>0 % if anything was touched
    touched_0=1;
end
end

function Save_Vid(vid_path,trial_name)
global cam_cell
frames={};
times={};
n_cams=length(cam_cell);
for i=1:n_cams;
    [save_frames,save_times]=getdata(cam_cell{i});
    save_name=sprintf('%s\\%s_v%i',vid_path,trial_name,i);
    save (save_name,'save_frames','save_times')
    frames{i}=save_frames;
end
figure
for i=1:size(frames{2},4)
    for j=1:n_cams
        subplot(1,n_cams,j)
        imshow(frames{j}(:,:,:,i))
    end
%     pause(1/30)
end

end

