
function varargout = gui_v5(varargin)

% A more user-friendly GUI interface for training and implementing the
% neural networks used to process FishOASIS data. Created with MATLAB
% GUIDE. 


% Edit the above text to modify the response to help gui_v5

% Last modified by H. Cai, 080618

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_v5_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_v5_OutputFcn, ...
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


% --- Executes just before gui_v5 is made visible.
function gui_v5_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_v5 (see VARARGIN)

% Choose default command line output for gui_v5
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_v5 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_v5_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in input_dir.
function input_dir_Callback(hObject, eventdata, handles)
% Get the data folder containing raw images. 
data_dir = uigetdir('C:/', 'Select data folder')

% Create the various directories needed for writing/moving images. 
mkdir(data_dir, '/sorted');
mkdir(data_dir, '/detection_output');
mkdir(data_dir, '/detection_output/agree');
mkdir(data_dir, '/detection_output/disagree');
mkdir(data_dir, '/detection_output/unverified');
mkdir(data_dir, '/classification_output');
mkdir(data_dir, '/classification_output/agree');
target_directory = strcat(data_dir, '/classification_output/agree');
write_classification_dirs
mkdir(data_dir, '/classification_output/disagree');
mkdir(data_dir, '/classification_output/unverified');
target_directory = strcat(data_dir, '/classification_output/unverified');
write_classification_dirs

% Set handles for use in later callbacks. 
handles.data_dir = data_dir;
handles.resize_dir = strcat(string(handles.data_dir), '/classification_output/agree');
handles.verification_case = 'none';

guidata(hObject, handles);

% --- Executes on button press in get_fishnet.
function get_fishnet_Callback(hObject, eventdata, handles)

% Load the version of fishnet. Refer to get_fishnet.m
handles.current_fishnet = get_fishnet();
guidata(hObject, handles)



% --- Executes on button press in train_fishnet.
function train_fishnet_Callback(hObject, eventdata, handles)

% Train the neural network. 

proceed = questdlg('Training a neural network will take significant time and resources. Are you sure you wish to proceed?', ...
    '', 'Yes', 'Cancel', 'Cancel');
switch proceed
    case 'Yes'
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



% --- Executes on button press in get_weights.
function get_weights_Callback(hObject, eventdata, handles)

% Load desired weights for YOLO
[weight_file, weight_path, filterindex] = uigetfile('*.weights', 'Select YOLO weights');
handles.weight_file = weight_file

guidata(hObject, handles)


% --- Executes on button press in run_yolomex.
function run_yolomex_Callback(hObject, eventdata, handles)

% Run object detection. There is an option for the user to verify any
% output. Refer to later callbacks for details. 
% 080618 Removed boxnet functionality to implement YOLO detection. 

if isfield(handles, 'data_dir') == 0 | handles.data_dir == 0
    errordlg('Load the data folder containing raw images.');
elseif isfield(handles, 'weight_file') == 0
    errordlg('Load the weights for object detection network.');
else
    % Call script to run YOLO and get output
    init_yolomex 
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
        handles.verification_case = 'boxnet';
        handles.detect_n = 1;

        else
            auto_move = questdlg('Automatically move images without verification?', ...
            '', 'Yes', 'No', 'No');

            switch auto_move
                case 'Yes'
                    % Run object detection and automatically sort
                    
                    files = dir(fullfile(char(handles.data_dir), '*jpg'));
                    for i = 1:length(files)
                        target_image = imread(fullfile(handles.data_dir, files(i).name));
                        detections = yolomex('detect', target_image, handles.threshold, handles.hier_threshold)
                        
                        if isempty(detections)
                            continue
                        else
                            for j = 1:length(detections)
                                % Crop and write image
                                square = max(detections(j).right - detections(j).left,...
                                    detections(j).bottom - detections(j).top);
                                crop_rect = [detections(j).left, detections(j).right, square, square]
                                current_crop = imcrop(target_image, crop_rect);
                                current_resize = imresize(current_crop, [227 227]);
                                crop_name = erase(files(i).name, '.jpg');
                                crop_name = strcat(crop_name, '-', int2str(j), '.jpg');
                                crop_name = strcat(handles.data_dir, '/detection_output/unverified/', crop_name);
                                imwrite(current_resize, char(crop_name));
                            end
                        end
                    end
                

                case 'No'
                        return
            end   

       end
    
    guidata(hObject, handles)
end



% --- Executes on button press in run_fishnet.
function run_fishnet_Callback(hObject, eventdata, handles)

% Run species classification. There is an option for the user to verify any
% output. Refer to later callbacks for details. 

if isfield(handles, 'data_dir') == 0 | handles.data_dir == 0
    errordlg('Load the data folder containing raw images.');
elseif numel(dir(strcat(handles.data_dir, '/detection_output/agree'))) < 3
    errordlg('Folder with resized images is empty.')
elseif isfield(handles, 'current_fishnet') == 0 
    errordlg('Load the species classification network.');
else
    fprintf('Classifying species/n')
    
    if get(handles.fishnet_verify, 'Value')
        % User verification is enabled. Refer to images_list callback for
        % details. 
        
        % Retrieve input directory based on whether user verified detection
        if get(handles.boxnet_verify, 'Value')
            % User should have verified results by hand
            resize_dir = strcat(handles.data_dir, '/detection_output/agree');
        else
            % User did not verify
            resize_dir = strcat(handles.data_dir, '/detection_output/unverified');
        end
        
        % Display list of resized images in listbox
        files = dir(fullfile(char(resize_dir), '*jpg'));
        for i = 1:length(files)
            temp{i} = files(i).name;
        end
        set(handles.images_list, 'String', temp);
        
        % Set handles
        handles.agree_dir = strcat(string(handles.data_dir), '/classification_output', '/agree/');
        handles.disagree_dir = strcat(string(handles.data_dir), '/classification_output', '/disagree');
        handles.resize_dir = resize_dir;
        handles.verification_case = 'fishnet';
                
    else
        auto_move = questdlg('Automatically move images without verification?', ...
            '', 'Yes', 'No', 'No');
        
        switch auto_move
            case 'Yes'
                
                % Run species classification on raw images specified by the input directory
                % Create datastore with raw images
                process_ds = imageDatastore(strcat(handles.data_dir, '/resize')); 
                [fishpreds, ~] = classify(handles.current_fishnet, process_ds);
                                
                % Move all images from resize into corresponding directories
                fprintf('Moving files/n')
                for i = 1:length(fishpreds)
                    target_image = convertStringsToChars(process_ds.Files{i});
                    target_dir = string(fishpreds(i));
                    target_dir = strcat(string(handles.data_dir), '/classification_output', '/unverified/', target_dir);
                    movefile(target_image, char(target_dir));
                end
                fprintf('Done/n');
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

    case 'boxnet'
        % Verification is being applied to boxnet; move images to disagree
        % folder
        crop_name = strcat(handles.data_dir, '/detection_output/disagree/', handles.root_name);
        imwrite(handles.current_resize, char(crop_name));
                
        
        % Check to see if this detection is the last one. If so, move to
        % the next image. 
        if handles.detect_n == handles.detectns
            temp = get(handles.images_list, 'Value')  ;          
            % Move onto the next one
            set(handles.images_list, 'Value', temp + 1);
            handles.detect_n = 1;            
            target_dir = strcat(handles.data_dir, '/sorted');
            movefile(char(handles.target_image), char(target_dir))
        else
            handles.detect_n = handles.detect_n + 1;
            
        end
        
        
        guidata(hObject, handles);
        images_list_Callback(hObject, eventdata, handles);
        
        
        
end
    


% --- Executes on button press in agree.
function agree_Callback(hObject, eventdata, handles)

% Button is displayed if user verification (for either network) is enabled.
% If user disagrees with output of either network, move images accordingly.


switch handles.verification_case
    case 'fishnet'
        % Verification is being applied to fishnet
        agree_dir = strcat(handles.agree_dir, '/', get(handles.candidate_species, 'String'));
        movefile(char(handles.target_image), char(agree_dir));

        % Update list of images, clear variables
        temp = get(handles.images_list, 'String');
        n = get(handles.images_list, 'Value');
        temp(n) = [];
        set(handles.images_list, 'Value', n);
        set(handles.images_list, 'String', temp);
       
    case 'boxnet'
        % Verification is being applied to boxnet; move images to resize
        % directory (in order to be used for fishnet classification)
        crop_name = strcat(handles.data_dir, '/detection_output/agree', handles.root_name);
        imwrite(handles.current_resize, char(crop_name));
        handles.detect_n = handles.detect_n + 1;
        

        % Check to see if this detection is the last one. If so, move to
        % the next image. 
        if handles.detect_n == handles.detectns
       
            temp = get(handles.images_list, 'Value');            
            % Move onto the next one
            set(handles.images_list, 'Value', temp + 1);
            handles.detect_n = 1;
            target_dir = strcat(handles.data_dir, '/sorted');
            movefile(char(handles.target_image), char(target_dir))
        else
            handles.detect_n = handles.detect_n + 1;
            
        end
        
        
        guidata(hObject, handles);
       
       images_list_Callback(hObject, eventdata, handles);
end

% --- Executes on selection change in images_list.
function images_list_Callback(hObject, eventdata, handles)

% Display list of images and run the selected image through a network. 
% The string is controlled by run_fishnet or run_yolomex callback. 

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
        handles.target_image = strcat(handles.resize_dir, '/', selected);
        
    case 'boxnet'
        % Run detection on an image
              
        target_image = imread(fullfile(char(handles.data_dir), cell2mat(selected)));
        detections = yolomex('detect', target_image, handles.threshold, handles.hier_threshold);
        detections.class
        
        % If there are no detections, move to the next image in the list. 
        if isempty(detections)
            temp = get(handles.images_list, 'Value');
            set(handles.images_list, 'Value', temp + 1);
            
        else 
            handles.detectns = length(detections.prob);
       
            % Display images one at a time. Crop parameters are in form of 
            % [X1 Y1 width height]. Resize to a square for input to classification 
            % network.
            j = handles.detect_n
            square = max(detections(j).right - detections(j).left,...
                detections(j).bottom - detections(j).top);
            crop_rect = [detections(j).left, detections(j).right, square, square];
            current_crop = imcrop(target_image, crop_rect);
            current_resize = imresize(current_crop, [227 227]);
            root_name = erase(selected, '.jpg');
            handles.root_name = strcat(root_name, '-', int2str(j), '.jpg');


            imshow(current_resize);
            handles.current_resize = current_resize;
        
        end 
        
        handles.target_image = strcat(handles.data_dir, '/', selected);

        
end

 guidata(hObject, handles);


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
