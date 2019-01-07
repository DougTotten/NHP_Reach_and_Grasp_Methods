function R2G_Load_Pellet (active_well)

% Move the active well to the loading position
move_time=R2G_Position_Wells (active_well,1);
R2G_Pellet ();
pause (1);
