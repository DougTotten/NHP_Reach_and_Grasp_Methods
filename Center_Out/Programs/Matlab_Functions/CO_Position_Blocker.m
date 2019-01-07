function CO_Position_Blocker (want_open)
global s_mot is_open

% Set feeder position, well positions, dump position
steps_per_rev=200;
gearing=1/(13+212/289);
deg_per_step=360/(steps_per_rev/gearing);

move_distance=18; % How far the motor will spin in degrees
move_steps=floor(move_distance/deg_per_step); % use floor because you can't take partial steps

if is_open
    if want_open
        % do nothing
    else % Close it
        fprintf(s_mot,'1\n%d',move_steps);
        moving_motor_txt=fscanf(s_mot);
        motor_finished_txt=fscanf(s_mot);
        is_open=0;
    end
else % is closed
    if want_open % open it
        fprintf(s_mot,'2\n%d',move_steps-2);
        moving_motor_txt=fscanf(s_mot);
        motor_finished_txt=fscanf(s_mot);
        is_open=1;
    else
        % do nothing
    end
end



