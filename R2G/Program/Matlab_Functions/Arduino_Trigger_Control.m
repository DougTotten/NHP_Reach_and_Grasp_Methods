function Arduino_Trigger_Control (s,onoff)

% This controls the an Arduino loaded with Camera_External_Trigger.ino
% s= serial connection to the arduino
% onoff= 1) Start 50hz trigger
% onoff= 0) Turn off 50hz trigger

fprintf (s,'%i\n',onoff);
cam_ctrl_txt=fscanf (s);
fprintf('\n%s',(cam_ctrl_txt(1:end-2)));