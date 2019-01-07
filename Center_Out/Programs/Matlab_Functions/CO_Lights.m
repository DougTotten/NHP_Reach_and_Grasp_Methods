function CO_Lights (s,led_states)

% This controls the lights for the arduino hooked up to the capacitive
% touch board for the center-out reaching task

% Variables:
% s is the serial object
% led_states is a 9-element binary vector with each element describing
% whether the LED will turn on or off

% LED assignment:
% center = 9
% counts up clockwise from 3oclock

%%% Light positions
%           1
%             
%     4           2
%              
%           3

dec_val=0; %will be used to convert the binary value into a decimal value
for i=1:9
    if led_states(i)
        dec_val=dec_val+2^(i-1);
    end
end
        
fprintf (s,'2/n%d',dec_val);
light_ctrl_txt=fscanf (s);
% fprintf('\n%s',(light_ctrl_txt(1:end-2))); % should read "Controlling
% Lights"