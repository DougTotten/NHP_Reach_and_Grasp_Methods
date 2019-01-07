function R2G_Lights (s,led_states)

% This controls the lights for the arduino hooked up to the stepper motor
% in the reach to grasp task



dec_val=0; %will be used to convert the binary value into a decimal value
for i=1:length(led_states)
    if led_states(i)
        dec_val=dec_val+2^(i-1);
    end
end

fprintf(s,'1\n');
fprintf (s,'%d',dec_val);
light_ctrl_txt=fscanf (s);
% fprintf('\n%s',(light_ctrl_txt(1:end-2)));
lights_done_txt=fscanf (s);
% fprintf('\n%s',(lights_done_txt(1:end-2)));
% dbstack
% keyboard