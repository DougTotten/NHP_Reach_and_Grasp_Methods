function varargout = CO_Interface(varargin)
% CO_INTERFACE MATLAB code for CO_Interface.fig
%      CO_INTERFACE, by itself, creates a new CO_INTERFACE or raises the existing
%      singleton*.
%
%      H = CO_INTERFACE returns the handle to a new CO_INTERFACE or the handle to
%      the existing singleton*.
%
%      CO_INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CO_INTERFACE.M with the given input arguments.
%
%      CO_INTERFACE('Property','Value',...) creates a new CO_INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CO_Interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CO_Interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CO_Interface

% Last Modified by GUIDE v2.5 10-Jul-2018 08:57:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CO_Interface_OpeningFcn, ...
                   'gui_OutputFcn',  @CO_Interface_OutputFcn, ...
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


% --- Executes just before CO_Interface is made visible.
function CO_Interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CO_Interface (see VARARGIN)

% Choose default command line output for CO_Interface
fullpath=mfilename('fullpath');
branch_path=fullpath(1:strfind(fullpath,mfilename)-1);
addpath(branch_path);
addpath([branch_path,'\Matlab_Functions'])
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CO_Interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CO_Interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop_script
stop_script=0;

fullpath=mfilename ('fullpath');
fname=mfilename;
fpath=fullpath(1:(findstr(fullpath,fname)-2));
addpath(fpath);

addpath(strcat(fpath,'\..\R2G_Program'))

CO_Wrap (handles)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global stop_script
stop_script=1;




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



function n_reps_Callback(hObject, eventdata, handles)
% hObject    handle to n_reps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_reps as text
%        str2double(get(hObject,'String')) returns contents of n_reps as a double
set (handles.n_trials,'String',num2str(str2num(get(handles.n_reps,'String')) * 4) );


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
hmin=str2num(get(handles.hold_min,'String'));
hmax=str2num(get(handles.hold_max,'String'));
if hmin>hmax
    set(handles.hold_max,'String',num2str(hmin));
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
hmin=str2num(get(handles.hold_min,'String'));
hmax=str2num(get(handles.hold_max,'String'));
if hmin>hmax
    set(handles.hold_min,'String',num2str(hmax));
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

global stop_script
stop_script=0;



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


% --- Executes on button press in cams_on.
function cams_on_Callback(hObject, eventdata, handles)
% hObject    handle to cams_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cams_on


% --- Executes on button press in mots_on.
function mots_on_Callback(hObject, eventdata, handles)
% hObject    handle to mots_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mots_on
if get(handles.mots_on,'Value')
    set (handles.load_time,'Enable','on')
else
    set (handles.load_time,'Enable','off')
end

% --- Executes on button press in nudge_c.
function nudge_c_Callback(hObject, eventdata, handles)
% hObject    handle to nudge_c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CO_Motor_Nudge (1)


% --- Executes on button press in nudge_cc.
function nudge_cc_Callback(hObject, eventdata, handles)
% hObject    handle to nudge_cc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CO_Motor_Nudge (0)



function load_time_Callback(hObject, eventdata, handles)
% hObject    handle to load_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of load_time as text
%        str2double(get(hObject,'String')) returns contents of load_time as a double


% --- Executes during object creation, after setting all properties.
function load_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to load_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in adjust_motor.
function adjust_motor_Callback(hObject, eventdata, handles)
% hObject    handle to adjust_motor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global is_open
was_open=is_open;
CO_Position_Blocker(1);
h=CO_Blocker_Adjust;
waitfor(h)
CO_Position_Blocker(was_open);


% --- Executes on button press in stim_on.
function stim_on_Callback(hObject, eventdata, handles)
% hObject    handle to stim_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stim_on
% dbstack
% keyboard

if get(handles.stim_on,'Value')
    
    n_reps=str2num(get(handles.n_reps,'String'));
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
    
