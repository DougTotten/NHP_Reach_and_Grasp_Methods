function [move_time]=R2G_Position_Wells (active_well,trial_phase)
global s_mot well_a_position 
% phases:
% 1) Loading
% 2) Presenting
% 3) Clearing

% Set feeder position, well positions, dump position
pellet_position=0;
ready_position=140;
reach_position=180;
clear_position=270; 
manual_position=30;

steps_per_rev=200;
gearing=1/(13+212/289);
fudge_factor1=0;
fudge_factor2=0;
% fudge_factor1=55/50; % was over-rotating by 55 degrees in 50 trials
% fudge_factor2=-25/500; % after correcting with above was under-rotating by 25 degrees in 500 trials
deg_per_step=(360+fudge_factor1+fudge_factor2)/(steps_per_rev/gearing);

switch active_well
    case 1 %well a
        well_offset=0;
    case 2 %well b
        well_offset=60;
    case 3 %well c
        well_offset=120;
    case 4 %well d
        well_offset=180;
    case 5 %well e
        well_offset=240;
    case 6 %well f
        well_offset=300;
end

switch trial_phase
    case 1 %loading pellet
        target_position=pellet_position;
%         fprintf ('\nMoving to Pellet Position\n')

    case 2 %pellet ready
        target_position=ready_position;
%         fprintf ('\nMoving to Reach Position\n')
        
    case 3 %presenting pellet
        target_position=reach_position;
%         fprintf ('\nMoving to Reach Position\n')
        
    case 4 %clearing pellet
        target_position=clear_position;
%         fprintf ('\nMoving to Clear Position\n')

    case 5 %manual pellet load
        target_position=manual_position;
end

active_well_position=well_a_position-well_offset;
if active_well_position<0
    active_well_position=active_well_position+360;
end

move_distance=target_position-active_well_position;
if move_distance<0
    move_distance=move_distance+360;
end

% Move wells counter-clockwise
if move_distance>360
    dbstack
    keyboard
end
move_steps=floor(move_distance/deg_per_step); % use floor because you can't take partial steps
move_distance=move_steps*deg_per_step; % accounts for rounding in previous step

if move_steps>2746
    dbstack
    keyboard
end

steps_per_sec=1000;
move_time=move_steps/steps_per_sec;

fprintf(s_mot,'2\n%d',move_steps);
moving_motor_txt=fscanf(s_mot);
motor_finished_txt=fscanf(s_mot);

% Update positions
well_a_position=well_a_position+move_distance; 
while well_a_position>360
    well_a_position=well_a_position-360;
end
