function sketch_id=CO_Initialize_Arduino_CapSense(com_chan)
global s_cap
% Run with arduino sketch R2G_MPR121_Interface

% Wiring Arduino to MPR121:
% Vin = 3-5 volts
% Grnd = grnd
% A4 = SDA
% A5 = SCL

s_cap=[];

instruments=instrfind();
for i=1:length(instruments)
    if strcmp(instruments(i).port,com_chan)
        fclose(instruments(i))
        delete (instruments(i))
    end
end

s_cap = serial(com_chan);    % define serial port
s_cap.BaudRate=9600;               % define baud rate
set(s_cap, 'terminator', 'LF');    % define the terminator for println
fopen(s_cap);

%%% Try / Catch note: will execute the portion in the Try block, and if
%%% there is an error, will replace the standard error behavior with the
%%% stuff in the "catch" block.
try % use try catch to ensure fclose
    % signal the arduino to start collection
    display ('Searching for handshake')
    w=fscanf(s_cap); % must define the input % d or %s, etc.
    if (strcmp(w(1:end-2),'Waiting for serial input'))
        display('Handshake detected');
        fprintf(s_cap,'%s\n','Serial input returned'); % establishContact just wants something in the buffer
    end
    
    cap_check_text=fscanf(s_cap); % should read "Serial connection established

    cap_check_text=fscanf(s_cap); % should read "Center_Out_MPR121
    cap_check_text=fscanf(s_cap); % should read "Checking MPR121 Capacitive Touch sensor connection
    display(cap_check_text(1:end-2));
    
    mpr_connect=fscanf(s_cap);
    if strcmp (mpr_connect(1:13), 'MPR121 found!')
        display (mpr_connect(1:end-2))
    else
        display ('Problem connecting with MPR121. Entering debug')
        dbstack
        keyboard
    end
     
catch exception
    
    fprintf ('\n')
    disp (exception.message);
    fprintf ('\n\n---- closing serial connection ---------\n')
    fclose(s_cap);                 % always, always want to close s_cap
end

