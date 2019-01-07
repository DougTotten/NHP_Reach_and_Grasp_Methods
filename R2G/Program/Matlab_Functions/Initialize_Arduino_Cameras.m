function sketch_id=Initialize_Arduino_Cameras(com_chan)
global s_cam
% Run with arduino sketch Camera_External_Trigger.ino

s_cam=[];

instruments=instrfind();
for i=1:length(instruments)
    if strcmp(instruments(i).port,com_chan)
        fclose(instruments(i))
    end
end

s_cam = serial(com_chan);    % define serial port
s_cam.BaudRate=9600;               % define baud rate
set(s_cam, 'terminator', 'LF');    % define the terminator for println
fopen(s_cam);

%%% Try / Catch note: will execute the portion in the Try block, and if
%%% there is an error, will replace the standard error behavior with the
%%% stuff in the "catch" block.
try                             % use try catch to ensure fclose
    % signal the arduino to start collection
    display ('Searching for handshake')
    w=fscanf(s_cam);              % must define the input % d or %s, etc.
    if (strcmp(w(1:24),'Waiting for serial input'))
        display('Handshake detected');
        fprintf(s_cam,'%s\n','Serial input returned');     % establishContact just wants
        % something in the buffer
    end
    
    cap_check_text=fscanf(s_cam); % should read "Connected\n"
    display(cap_check_text(1:end-2));
    
catch exception
    
    fprintf ('\n')
    disp (exception.message);
    fprintf ('\n\n---- closing serial connection ---------\n')
    fclose(s_cam);                 % always, always want to close s_cam
end

