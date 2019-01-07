
function Track_Time (start_time,handles)
% % time_now=double(tic);
% time_lapsed=(time_now-double(start_time))/1000000;
time_lapsed=toc(start_time);
mins=floor(time_lapsed/60);
secs10=floor((time_lapsed-mins*60)/10);
secs1=floor(time_lapsed-mins*60-secs10*10);
tl_txt=sprintf ('%i:%i%i ',mins,secs10,secs1);
set(handles.time_txt,'String',tl_txt);