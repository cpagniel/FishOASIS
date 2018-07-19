
function varargout = gui_v4(varargin)

% A more user-friendly GUI interface for training and implementing the
% neural networks used to process FishOASIS data. Created with MATLAB
% GUIDE. 


% Edit the above text to modify the response to help gui_v4

% Last Modified by H. Cai, 071318

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_v4_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_v4_OutputFcn, ...
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


% --- Executes just before gui_v4 is made visible.
function gui_v4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_v4 (see VARARGIN)

% Choose default command line output for gui_v4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_v4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_v4_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in input_dir.
function input_dir_Callback(hObject, eventdata, handles)
% Get the data folder containing raw images. 
data_dir = uigetdir('C:\', 'Select data folder')

% Create the various directories needed for writing/moving images. 
mkdir(data_dir, '\detection_output');
mkdir(data_dir, '\detection_output\agree');
mkdir(data_dir, '\detection_output\disagree');
mkdir(data_dir, '\resize');
mkdir(data_dir, '\classification_output');
mkdir(data_dir, '\classification_output\agree');
target_directory = strcat(data_dir, '\classification_output\agree');
write_classification_dirs
mkdir(data_dir, '\classification_output\disagree');
mkdir(data_dir, '\classification_output\unverified');
target_directory = strcat(data_dir, '\classification_output\unverified');
write_classification_dirs

% Set handles for use in later callbacks. 
handles.data_dir = data_dir;
handles.resize_dir = strcat(string(handles.data_dir), '\resize');
handles.verification_case = 'none';

guidata(hObject, handles);


% --- Executes on button press in get_boxnet.
function get_boxnet_Callback(hObject, eventdata, handles)

% Load the version of boxnet. Refer to get_boxnet.m
handles.current_boxnet = get_boxnet();
guidata(hObject, handles)


% --- Executes on button press in get_fishnet.
function get_fishnet_Callback(hObject, eventdata, handles)

% Load the version of boxnet. Refer to get_fishnet.m
handles.current_fishnet = get_fishnet();
guidata(hObject, handles)


% --- Executes on button press in train_boxnet.
function train_boxnet_Callback(hObject, eventdata, handles)

% Train the neural network. 

proceed = questdlg('Training a neural network will take significant time and resources. Are you sure you wish to proceed?', ...
    '', 'Yes', 'Cancel', 'Cancel');
switch proceed
    case 'Yes'
        % TODO: Allow for UI of selecting training version
        old_dir = pwd;
        cd boxnet;
        draw_boxes_v0_1
        cd(old_dir)
        handles.current_boxnet = get_boxnet();
        guidata(hObject, handles)
    case 'No' 
        msgbox('Boxnet training cancelled');
end


% --- Executes on button press in train_fishnet.
function train_fishnet_Callback(hObject, eventdata, handles)

% Train the neural network. 

proceed = questdlg('Training a neural network will take significant time and resources. Are you sure you wish to proceed?', ...
    '', 'Yes', 'Cancel', 'Cancel');
switch proceed
    case 'Yes'
        % TODO: Allow for UI of selecting training version
        train_fishnet_version = uigetfile('*.m', 'Select version of fishnet to train.')
        warndlg('Are you sure you want to train this version of fishnet?', 'Confirm');
        old_dir = pwd;
        cd fishnet;
        run(train_fishnet_version);
        cd(old_dir)
        handles.current_fishnet = get_fishnet();
        guidata(hObject, handles)
    case 'No' 
        msgbox('Boxnet training cancelled');
end


% --- Executes on button press in run_boxnet.
function run_boxnet_Callback(hObject, eventdata, handles)

% Run object detection. There is an option for the user to verify any
% output. Refer to later callbacks for details. 

if isfield(handles, 'data_dir') == 0 | handles.data_dir == 0
    errordlg('Load the data folder containing raw images.');
elseif isfield(handles, 'current_boxnet') == 0
    errordlg('Load the object detection network.');
else
    % Run object detection using current_boxnet. Refer to later
    % callbacks for switch cases. 
    
    if get(handles.boxnet_verify, 'Value')
        % User verification is enabled. Refer to images_list callback for
        % details. 
        
        % Display list of resized images in listbox
        files = dir(fullfile(char(handles.data_dir), '*jpg'));
        for i = 1:length(files)
            temp{i} = files(i).name;
        end
        set(handles.images_list, 'String', temp);
    
        % Set handles
        handles.agree_dir = strcat(string(handles.data_dir), '\detection_output', '\agree\');
        handles.disagree_dir = strcat(string(handles.data_dir), '\detection_output', '\disagree');
        handles.verification_case = 'boxnet';
        
    else
        auto_move = questdlg('Automatically move images without verification?', ...
        '', 'Yes', 'No', 'No');
        
        switch auto_move
            case 'Yes'
                return
                
                  % TODO: Modify for output suited to boxnet
%                 % Run object detection on raw images specified by the input directory
%                 set(handles.wait_text, 'visible', 'on');
% 
%                 set(handles.wait_text, 'visible', 'off');
%                                 
%                 % Move all images from raw image directory to detection
%                 output
%                 fprintf('Moving files\n')
%                 for i = 1:length(fishpreds)
%                     target_image = convertStringsToChars(process_ds.Files{i});
%                     target_dir = string(fishpreds(i));
%                     target_dir = strcat(string(handles.data_dir), '\classification_output', '\unverified\', target_dir);
%                     movefile(target_image, convertStringsToChars(target_dir));
%                 end
%                 fprintf('Done\n');

            case 'No'
                return
        end
  end

    guidata(hObject, handles)
end

% --- Executes on button press in resize_images.
function resize_images_Callback(hObject, eventdata, handles)

% Run the intermediate step: output images from object detection must be
% resized to [227 227 3] images for species classification. 

if isfield(handles, 'data_dir') == 0 | handles.data_dir == 0
    errordlg('Load the data folder containing raw images.');
elseif numel(dir(strcat(handles.data_dir, '\detection_output\agree'))) < 3
    errordlg('Folder with detection output images is empty. Run detection on images.')
else
    set(handles.wait_text, 'visible', 'on');
    fprintf('Resizing images\n')
    resize_images
    fprintf('Done\n')
    set(handles.wait_text, 'visible', 'off');
end

handles.resize_dir = resize_dir;
guidata(hObject, handles);


% --- Executes on button press in run_fishnet.
function run_fishnet_Callback(hObject, eventdata, handles)

% Run species classification. There is an option for the user to verify any
% output. Refer to later callbacks for details. 

if isfield(handles, 'data_dir') == 0 | handles.data_dir == 0
    errordlg('Load the data folder containing raw images.');
elseif numel(dir(strcat(handles.data_dir, '\resize'))) < 3
    errordlg('Folder with resized images is empty. Run resizing.')
elseif isfield(handles, 'current_fishnet') == 0 
    errordlg('Load the species classification network.');
else
    fprintf('Classifying species\n')
     
    if get(handles.fishnet_verify, 'Value')
        % User verification is enabled. Refer to images_list callback for
        % details. 
        
        % Display list of resized images in listbox
        files = dir(fullfile(char(handles.resize_dir), '*jpg'));
        for i = 1:length(files)
            temp{i} = files(i).name;
        end
        set(handles.images_list, 'String', temp);
        
        % Set handles
        handles.agree_dir = strcat(string(handles.data_dir), '\classification_output', '\agree\');
        handles.disagree_dir = strcat(string(handles.data_dir), '\classification_output', '\disagree');
        handles.verification_case = 'fishnet';
                
    else
        auto_move = questdlg('Automatically move images without verification?', ...
            '', 'Yes', 'No', 'No');
        
        switch auto_move
            case 'Yes'
                
                % Run species classification on raw images specified by the input directory
                set(handles.wait_text, 'visible', 'on');
                % Create datastore with raw images
                process_ds = imageDatastore(strcat(handles.data_dir, '\resize')); 
                [fishpreds, ~] = classify(handles.current_fishnet, process_ds);

                set(handles.wait_text, 'visible', 'off');
                                
                % Move all images from resize into corresponding directories
                fprintf('Moving files\n')
                for i = 1:length(fishpreds)
                    target_image = convertStringsToChars(process_ds.Files{i});
                    target_dir = string(fishpreds(i));
                    target_dir = strcat(string(handles.data_dir), '\classification_output', '\unverified\', target_dir);
                    movefile(target_image, convertStringsToChars(target_dir));
                end
                fprintf('Done\n');
            case 'No'
                return
        end
    end
    
    guidata(hObject, handles);
    
end


% --- Executes on button press in boxnet_verify.
function boxnet_verify_Callback(hObject, eventdata, handles)

% Enable user verification of object detection results. Display buttons
% accordingly. 

if get(handles.boxnet_verify, 'Value')
    set(handles.verification_group, 'visible', 'on');
else
    set(handles.verification_group, 'visible', 'off');    
end


% --- Executes on button press in fishnet_verify.
function fishnet_verify_Callback(hObject, eventdata, handles)

% Enable user verification of object detection results. Display buttons
% accordingly. 

if get(handles.fishnet_verify, 'Value')
    set(handles.verification_group, 'visible', 'on');
else
    set(handles.verification_group, 'visible', 'off');    
end


% --- Executes on button press in disagree.
function disagree_Callback(hObject, eventdata, handles)

% Button is displayed if user verification (for either network) is enabled.
% If user disagrees with output of either network, move images accordingly.


switch handles.verification_case
    case 'fishnet'
        % Verification is being applied to fishnet
        movefile(char(handles.target_image), char(handles.disagree_dir));

        % Update list of images
        temp = get(handles.images_list, 'String');
        n = get(handles.images_list, 'Value');
        temp(n) = [];
        set(handles.images_list, 'Value', n)
        set(handles.images_list, 'String', temp);


        guidata(hObject, handles)
    case 'boxnet'
        % Verification is being applied to boxnet
        % TODO: Move images to disagree folder
        return
end
    


% --- Executes on button press in agree.
function agree_Callback(hObject, eventdata, handles)

% Button is displayed if user verification (for either network) is enabled.
% If user disagrees with output of either network, move images accordingly.


switch handles.verification_case
    case 'fishnet'
        % Verification is being applied to fishnet
        agree_dir = strcat(handles.agree_dir, '\', get(handles.candidate_species, 'String'));
        movefile(char(handles.target_image), char(agree_dir));

        % Update list of images, clear variables
        temp = get(handles.images_list, 'String');
        n = get(handles.images_list, 'Value');
        temp(n) = [];
        set(handles.images_list, 'Value', n);
        set(handles.images_list, 'String', temp);


        guidata(hObject, handles)
    case 'boxnet'
        % Verification is being applied to boxnet
        % TODO: Move images to disagree folder
        return
end

% --- Executes on selection change in images_list.
function images_list_Callback(hObject, eventdata, handles)

% Display list of images and run the selected image through a network. 
% The string is controlled by run_fishnet or run_boxnet callback. 

temp = get(handles.images_list, 'String');
selected = temp(get(handles.images_list, 'Value'));

% Decide what to do, depending on what network is being verified. 
switch handles.verification_case
    case 'fishnet'
        I = imread(fullfile(char(handles.resize_dir), cell2mat(selected)));
        imshow(I, 'InitialMagnification', 'fit', 'Parent', handles.main_axes);
   
        % Run classification and display candidate species name
        set(handles.candidate_species, 'visible', 'on');
        [fishpred, ~] = classify(handles.current_fishnet, I)
        set(handles.candidate_species, 'string', string(fishpred));
        
    case 'boxnet'
        % TODO: Run detection on an image
        I = imread(fullfile(char(handles.data_dir), cell2mat(selected)));
        imshow(I, 'InitialMagnification', 'fit', 'Parent', handles.main_axes);
        % Draw the candidate box on top
end

% User:  Agree or disagree? Move images accordingly. 
% See agree and disagree callback
 handles.target_image = strcat(handles.resize_dir, '\', selected);
 guidata(hObject, handles)





% --- Executes during object creation, after setting all properties.
function images_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to images_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


            
            


% --- Executes on button press in help.
function help_Callback(hObject, eventdata, handles)
temp = strcat('This app was developed in the summer of 2018 by Helen Cai', ...
    ' to aid in automatically processing image data taken for the FishOASIS project.',...
    newline, ...
    ' For questions in its functionality or use, contact helen.cai@yale.edu.');
msgbox(temp)
