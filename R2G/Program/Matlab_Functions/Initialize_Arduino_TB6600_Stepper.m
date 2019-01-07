function sketch_id=Initialize_Arduino_TB6600_Stepper(com_chan)
global s_mot
% Wiring:
% Grnd --> ENA- (I wired all grnds to connect)
% pin 7 --> ENA+ (enable) 
% pin 8 --> DIR+ (direction)
% pin 9 --> PUL+ (pulse)

s_mot=[];

instruments=instrfind();
for i=1:length(instruments)
    if strcmp(instruments(i).port,com_chan)
        fclose(instruments(i))
    end
end

s_mot = serial(com_chan);    % define serial port
s_mot.BaudRate=9600;               % define baud rate
set(s_mot, 'terminator', 'LF');    % define the terminator for println
fopen(s_mot);

%%% Try / Catch note: will execute the portion in the Try block, and if
%%% there is an error, will replace the standard error behavior with the
%%% stuff in the "catch" block.
try                             % use try catch to ensure fclose
    % signal the arduino to start collection
    display ('Searching for handshake')
    w=fscanf(s_mot);              % must define the input % d or %s, etc.
    if (strcmp(w(1:end-2),'Stepper and Pellet Control: Waiting for serial port input'))
        display('Handshake detected');
        fprintf(s_mot,'%s\n','Serial input returned');     % establishContact just wants
        % something in the buffer
    end
    
    serial_ver_text=fscanf(s_mot); % should read "Serial connection established"
    display(serial_ver_text(1:end-2));
    
     
catch exception
    
    fprintf ('\n')
    disp (exception.message);
    fprintf ('\n\n---- closing serial connection ---------\n')
    fclose(s_mot);                 % always, always want to close s_mot
end

