function t_out=Read_MPR121_CO(s1)
% Written by DJT 2/16/17
% This is designed to be run with the arduino sketch "MPR121_Interface".
% That needs to be loaded to the arduino separately.
% Make a serial connection to the MPR121 and set up a global serial port
% object
% Once that connection is made, any serial input will trigger the arduino
% to return the capacitive touch sensor values with the serial output

% This version works to read 9 or fewer cap-sensor inputs

reorder_numbers=[1:9];
    
fprintf(s1,'1\n0') % 1 is for read sensor, 0 is a dummy
s_in=fscanf(s1,'%u');
touched=dec2bin(s_in)-'0'; % convert to a binary vector
touched=[zeros(1,12-length(touched)) touched];
touched=fliplr(touched);
t_out=zeros(1,9);
t_out(reorder_numbers(logical(touched(2:10))))=1;
 


