function R2G_Pellet ()

% This controls the pellet dispensor for the reach to grasp task
% This is made to operate an Arduino loaded with TB6600_Driver_and_Pellet_Matlab.ino

global s_mot

fprintf(s_mot,'1\n0');
pellet_ctrl_txt=fscanf (s_mot);
fprintf('\n%s',(pellet_ctrl_txt(1:end-2)));
pellet_done_txt=fscanf (s_mot);
fprintf('\n%s',(pellet_done_txt(1:end-2)));
% dbstack
% keyboard