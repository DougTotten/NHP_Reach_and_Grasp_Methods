function CO_Trial_Code (s,trial_number)

% Tell the arduino to flicker the lights in binary sequence indicating
% trial number
% This works with an Arduino sketch that codes with 3 lights
% first light flickers on and off rapidly (w/ timing dependent on camera
% frame-rate) that indicates start of light-coding period
% then for 8 pulses, flick light 2 on
% flick light 3 on at the same time as light 2 to indicate a 0 or 1,
% providing the binary code
% flicker light 1 three times again to indicate end of coding period

fprintf (s,'3/n%d',trial_number);
light_ctrl_txt=fscanf (s);