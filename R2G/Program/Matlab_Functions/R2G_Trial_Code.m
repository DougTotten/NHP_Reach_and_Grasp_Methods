function R2G_Trial_Code (s,trial_number)
% This controls LED trial-light indicators for a an Arduino loaded with
% R2G_MPR121_Interface.ino

fprintf (s,'3/n%d',trial_number);
light_ctrl_txt=fscanf (s);