function Update_nTrials(handles)
% Support function for R2G_Interface 

w37=get(handles.w37,'Value');
w31=get(handles.w31,'Value');
w25=get(handles.w25,'Value');
w19=get(handles.w19,'Value');
w13=get(handles.w13,'Value');
w10=get(handles.w10,'Value');

n_reps=str2num(get(handles.n_reps,'String'));

n_trials=n_reps*(w37+w31+w25+w19+w13+w10);
set (handles.n_trials_txt,'String',num2str(n_trials));