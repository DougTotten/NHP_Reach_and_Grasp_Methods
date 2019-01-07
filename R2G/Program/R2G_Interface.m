function varargout = R2G_Interface(varargin)
% R2G_INTERFACE MATLAB code for R2G_Interface.fig
%      R2G_INTERFACE, by itself, creates a new R2G_INTERFACE or raises the existing
%      singleton*.
%
%      H = R2G_INTERFACE returns the handle to a new R2G_INTERFACE or the handle to
%      the existing singleton*.
%
%      R2G_INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in R2G_INTERFACE.M with the given input arguments.
%
%      R2G_INTERFACE('Property','Value',...) creates a new R2G_INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before R2G_Interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to R2G_Interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help R2G_Interface

% Last Modified by GUIDE v2.5 16-Jul-2018 09:55:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @R2G_Interface_OpeningFcn, ...
                   'gui_OutputFcn',  @R2G_Interface_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before R2G_Interface is made visible.
function R2G_Interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to R2G_Interface (see VARARGIN)

global stop_script

fullpath=mfilename ('fullpath');
fname=mfilename;
fpath=fullpath(1:(findstr(fullpath,fname)-2));
addpath([fpath,'\Matlab_Functions'])

stop_script=0;

% Choose default command line output for R2G_Interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes R2G_Interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = R2G_Interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function n_reps_Callback(hObject, eventdata, handles)
% hObject    handle to n_reps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_reps as text
%        str2double(get(hObject,'String')) returns contents of n_reps as a double

Update_nTrials(handles)

% --- Executes during object creation, after setting all properties.
function n_reps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_reps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hold_min_Callback(hObject, eventdata, handles)
% hObject    handle to hold_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hold_min as text
%        str2double(get(hObject,'String')) returns contents of hold_min as a double
hold_min=str2num(get(handles.hold_min,'String'));
hold_max=str2num(get(handles.hold_max,'String'));
if hold_min>hold_max
    set (handles.hold_max,'String',num2str(hold_min));
end


% --- Executes during object creation, after setting all properties.
function hold_min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hold_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hold_max_Callback(hObject, eventdata, handles)
% hObject    handle to hold_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hold_max as text
%        str2double(get(hObject,'String')) returns contents of hold_max as a double
hold_min=str2num(get(handles.hold_min,'String'));
hold_max=str2num(get(handles.hold_max,'String'));
if hold_min>hold_max
    set (handles.hold_min,'String',num2str(hold_max));
end


% --- Executes during object creation, after setting all properties.
function hold_max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hold_max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trial_time_Callback(hObject, eventdata, handles)
% hObject    handle to trial_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of trial_time as text
%        str2double(get(hObject,'String')) returns contents of trial_time as a double


% --- Executes during object creation, after setting all properties.
function trial_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to trial_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function punish_time_Callback(hObject, eventdata, handles)
% hObject    handle to punish_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of punish_time as text
%        str2double(get(hObject,'String')) returns contents of punish_time as a double



% --- Executes during object creation, after setting all properties.
function punish_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to punish_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop_script
stop_script=0;
R2G_Wrap (handles);


% --- Executes on button press in w37.
function w37_Callback(hObject, eventdata, handles)
% hObject    handle to w37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of w37
Update_nTrials(handles)


% --- Executes on button press in w31.
function w31_Callback(hObject, eventdata, handles)
% hObject    handle to w31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of w31
Update_nTrials(handles)


% --- Executes on button press in w25.
function w25_Callback(hObject, eventdata, handles)
% hObject    handle to w25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of w25
Update_nTrials(handles)


% --- Executes on button press in w19.
function w19_Callback(hObject, eventdata, handles)
% hObject    handle to w19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of w19
Update_nTrials(handles)


% --- Executes on button press in w13.
function w13_Callback(hObject, eventdata, handles)
% hObject    handle to w13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of w13
Update_nTrials(handles)


% --- Executes on button press in w10.
function w10_Callback(hObject, eventdata, handles)
% hObject    handle to w10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of w10
Update_nTrials(handles)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop_script
stop_script=1;


% --- Executes on button press in w37.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to w37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of w37


% --- Executes on button press in w31.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to w31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of w31


% --- Executes on button press in w25.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to w25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of w25


% --- Executes on button press in w19.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to w19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of w19


% --- Executes on button press in w13.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to w13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of w13


% --- Executes on button press in w10.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to w10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of w10



function monk_name_Callback(hObject, eventdata, handles)
% hObject    handle to monk_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of monk_name as text
%        str2double(get(hObject,'String')) returns contents of monk_name as a double


% --- Executes during object creation, after setting all properties.
function monk_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to monk_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in man_pel.
function man_pel_Callback(hObject, eventdata, handles)
% hObject    handle to man_pel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of man_pel
if get(handles.man_pel,'Value')
    set (handles.man_pel_time,'Enable','on')
else
    set (handles.man_pel_time,'Enable','off')
end


% --- Executes during object creation, after setting all properties.
function n_trials_txt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_trials_txt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in cams_on.
function cams_on_Callback(hObject, eventdata, handles)
% hObject    handle to cams_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cams_on


% --- Executes on selection change in man_pel_time.
function man_pel_time_Callback(hObject, eventdata, handles)
% hObject    handle to man_pel_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns man_pel_time contents as cell array
%        contents{get(hObject,'Value')} returns selected item from man_pel_time


% --- Executes during object creation, after setting all properties.
function man_pel_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to man_pel_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stim_on.
function stim_on_Callback(hObject, eventdata, handles)
% hObject    handle to stim_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stim_on

if get(handles.stim_on,'Value')
    
    n_reps=str2num(get(handles.n_reps,'String'));
%     n_stim=round(n_reps/3);
%     pre_stim=floor( (n_reps-n_stim)/2);
%     post_stim=ceil( (n_reps-n_stim)/2);
    n_stim=round(n_reps/2);
    pre_stim=0;
    post_stim=n_reps-n_stim;
    
    set(handles.pre_block,'String',num2str(pre_stim))
    set(handles.stim_block,'String',num2str(n_stim))
    set(handles.post_block,'String',num2str(post_stim))
    
else
    
    set(handles.pre_block,'String','--')
    set(handles.stim_block,'String','--')
    set(handles.post_block,'String','--')
    
end



function pre_block_Callback(hObject, eventdata, handles)
% hObject    handle to pre_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pre_block as text
%        str2double(get(hObject,'String')) returns contents of pre_block as a double


% --- Executes during object creation, after setting all properties.
function pre_block_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pre_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stim_block_Callback(hObject, eventdata, handles)
% hObject    handle to stim_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim_block as text
%        str2double(get(hObject,'String')) returns contents of stim_block as a double


% --- Executes during object creation, after setting all properties.
function stim_block_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function post_block_Callback(hObject, eventdata, handles)
% hObject    handle to post_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of post_block as text
%        str2double(get(hObject,'String')) returns contents of post_block as a double


% --- Executes during object creation, after setting all properties.
function post_block_CreateFcn(hObject, eventdata, handles)
% hObject    handle to post_block (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in adjust_wells.
function adjust_wells_Callback(hObject, eventdata, handles)
% hObject    handle to adjust_wells (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global adjust_well

adjust_well=1;
