function varargout = draw_overlap(varargin)
% DRAW_OVERLAP MATLAB code for draw_overlap.fig
%      
%       081118
%       Helen Cai
%       A short GUI to view real and proposed ROIs (as given by the silhouetting method).
%       Should be phased out as better metrics are implemented. 
%
%      DRAW_OVERLAP, by itself, creates a new DRAW_OVERLAP or raises the existing
%      singleton*.
%
%      H = DRAW_OVERLAP returns the handle to a new DRAW_OVERLAP or the handle to
%      the existing singleton*.
%
%      DRAW_OVERLAP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DRAW_OVERLAP.M with the given input arguments.
%
%      DRAW_OVERLAP('Property','Value',...) creates a new DRAW_OVERLAP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before draw_overlap_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to draw_overlap_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help draw_overlap

% Last Modified by GUIDE v2.5 07-Aug-2018 10:00:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @draw_overlap_OpeningFcn, ...
                   'gui_OutputFcn',  @draw_overlap_OutputFcn, ...
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


% --- Executes just before draw_overlap is made visible.
function draw_overlap_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to draw_overlap (see VARARGIN)

% Get data and make list of file names
data_dir = uigetdir('', 'Select data folder');
data_files = dir(fullfile(char(data_dir), '*jpg'));
for i = 1:length(data_files)
   temp{i} = strcat(data_dir, '/', data_files(i).name);
end


% Set handles
handles.files = data_files;
handles.image_list = temp;
handles.image_n = 0;

% Choose default command line output for draw_overlap
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes draw_overlap wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% ---- Called by the forward and back buttons ---
function display(handles)
% Display image
handles.image_list(handles.image_n)
I = imread(char(handles.image_list(handles.image_n)));
imshow(I);


% Annotate image according to text file with the same name
temp = textname(handles.files, handles.image_n)
detections = dlmread(temp);
for i = 1:length(detections)
    % Draw rectangle
    rect = detections(i, :)
    rectangle('Position', rect, 'EdgeColor', 'y');
end




% --- Outputs from this function are returned to the command line.
function varargout = draw_overlap_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in forward.
function forward_Callback(hObject, eventdata, handles)
% hObject    handle to forward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.image_n = handles.image_n + 1;
guidata(hObject, handles)
display(handles)


% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.image_n = handles.image_n - 1;
guidata(hObject, handles)
display(handles)
