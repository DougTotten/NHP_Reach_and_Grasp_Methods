function varargout = CO_Blocker_Adjust(varargin)
% CO_BLOCKER_ADJUST MATLAB code for CO_Blocker_Adjust.fig
%      CO_BLOCKER_ADJUST, by itself, creates a new CO_BLOCKER_ADJUST or raises the existing
%      singleton*.
%
%      H = CO_BLOCKER_ADJUST returns the handle to a new CO_BLOCKER_ADJUST or the handle to
%      the existing singleton*.
%
%      CO_BLOCKER_ADJUST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CO_BLOCKER_ADJUST.M with the given input arguments.
%
%      CO_BLOCKER_ADJUST('Property','Value',...) creates a new CO_BLOCKER_ADJUST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CO_Blocker_Adjust_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CO_Blocker_Adjust_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CO_Blocker_Adjust

% Last Modified by GUIDE v2.5 21-Aug-2017 10:43:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CO_Blocker_Adjust_OpeningFcn, ...
                   'gui_OutputFcn',  @CO_Blocker_Adjust_OutputFcn, ...
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


% --- Executes just before CO_Blocker_Adjust is made visible.
function CO_Blocker_Adjust_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CO_Blocker_Adjust (see VARARGIN)

% Choose default command line output for CO_Blocker_Adjust
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CO_Blocker_Adjust wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CO_Blocker_Adjust_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in open_close.
function open_close_Callback(hObject, eventdata, handles)
% hObject    handle to open_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CO_Position_Blocker(0);
pause (.5);
CO_Position_Blocker(1);
pause (.5);


% --- Executes on button press in nudge_cw.
function nudge_cw_Callback(hObject, eventdata, handles)
% hObject    handle to nudge_cw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CO_Motor_Nudge (0)


% --- Executes on button press in nudge_ccw.
function nudge_ccw_Callback(hObject, eventdata, handles)
% hObject    handle to nudge_ccw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

CO_Motor_Nudge (1)


% --- Executes on button press in done.
function done_Callback(hObject, eventdata, handles)
% hObject    handle to done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close (handles.figure1)


% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
% hObject    handle to close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CO_Position_Blocker(0);


% --- Executes on button press in open.
function open_Callback(hObject, eventdata, handles)
% hObject    handle to open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
CO_Position_Blocker(1);
