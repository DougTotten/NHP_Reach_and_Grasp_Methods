function CO_Motor_Nudge (direction)
% Takes inpue 1 for clockwise, 0 for counterclockwise

global s_mot is_open


% Set feeder position, well positions, dump position
steps_per_rev=200;
gearing=1/(13+212/289);
deg_per_step=360/(steps_per_rev/gearing);

move_distance=.5;
move_steps=floor(move_distance/deg_per_step); % use floor because you can't take partial steps

if direction==1
    fprintf(s_mot,'1\n%d',move_steps);
    moving_motor_txt=fscanf(s_mot);
    motor_finished_txt=fscanf(s_mot);
else
    fprintf(s_mot,'2\n%d',move_steps);
    moving_motor_txt=fscanf(s_mot);
    motor_finished_txt=fscanf(s_mot);
end



