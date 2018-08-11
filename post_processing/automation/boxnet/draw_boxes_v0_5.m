% 070618
% Helen Cai
%
% An example of object detection using Faster R-CNN. See 
% https://www.mathworks.com/help/vision/examples/object-detection-using-faster-r-cnn-deep-learning.html
% for more details. 
% Note: instead of using a datastore for training data, this R-CNN simply
% uses a table holding both filenames and the locations of boxes within the
% image. 


% TODO: Train the CNN and evaluate performance. 
% TODO: Gather more data and train with better dataset. 

% Load the dataset. Determine if training data has been previously processed
data_exist = questdlg('Is there image data that has already been preprocessed and marked with boxes?',...
    '', 'Yes', 'No', 'No');
switch data_exist
    case 'Yes'
        data_file = uigetfile('', 'Select file containing box data (in same folder as training images). Must be called "box_dataset.mat"');
    case 'No'
        write_box_data
        disp('Box data has been processed.')
        data_file = (strcat(target_directory, '\box_dataset.mat'));
end

load(data_file);

% 071318
% Rewrite path names
for i = 1:height(box_dataset)
    temp = replace(box_dataset.image_names{i}, 'E:\', '\\tsclient\E\');
    box_dataset.image_names{i} = temp
end

% Optional: read, label, and display one of the images 
I = imread(box_dataset.image_names{20});
I = insertShape(I, 'Rectangle', box_dataset.boxes{20});
I = imresize(I, 0.2);
imshow(I);

% Split the data set. Set 60% of the data for training and the rest for
% evaluation
idx = floor(0.6 * height(box_dataset));
trainingData = box_dataset(1:idx,:)
testData = box_dataset(idx:end,:)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the input layer.
% This defines the type and size of input. For detection tasks, 
% the input size must be similar in size to the
% smallest object int the data set. 

inputLayer = imageInputLayer([32 32 3]);

% Create the middle layers of the network. 
filterSize = [3 3];
numFilters = 32;

middleLayers = [                
    convolution2dLayer(filterSize, numFilters, 'Padding', 2)   
    reluLayer()
    convolution2dLayer(filterSize, numFilters, 'Padding', 2)  
    reluLayer() 
    maxPooling2dLayer(3, 'Stride',2)  
    convolution2dLayer(filterSize, numFilters, 'Padding', 2)
    reluLayer()
    ];

% Create the final layers of the network
n = 64;
finalLayers = [   
    fullyConnectedLayer(n)

    reluLayer()
    
    % 070618
    % Add a batch normalization layer (an updated method to dropout)
    batchNormalizationLayer()
    fullyConnectedLayer(width(box_dataset))
    softmaxLayer()
    classificationLayer()
];


layers = [
    inputLayer
    middleLayers
    finalLayers
    ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Configure options and train the detector. 
% mkdir temp
% temp_dir = strcat(pwd, '\temp');
temp_dir = '\\tsclient\E\FishOASIS_CNN\boxnet\temp';

% trainFasterRCNNObjectDetector() trains the detector in 4 steps. 

% The first two steps train the region proposal and detection networks used
% in Faster R-CNN. 

options_stage1 = trainingOptions('sgdm',...
    'ExecutionEnvironment','parallel', ... % Turn on built-in parallel support.
           'InitialLearnRate', 0.001, ...
           'Plots', 'training-progress',...
           'MaxEpochs', 10, ...
           'MiniBatchSize', 256, ...
           'CheckpointPath', temp_dir);

options_stage2 = trainingOptions('sgdm', ...
     'ExecutionEnvironment','parallel', ... % Turn on built-in parallel support.
            'InitialLearnRate', 0.001, ...
            'Plots', 'training-progress', ...
            'MaxEpochs', 10, ...
            'MiniBatchSize', 128, ...
            'CheckpointPath', temp_dir);

% The final two steps combine the networks from the first two steps such
% that a single network is created for detection. These network weights can
% be modified more slowly than in the first two steps. 

options_stage3 = trainingOptions('sgdm', ...
    'ExecutionEnvironment','parallel', ... % Turn on built-in parallel support.
            'InitialLearnRate', 0.001, ...
            'Plots', 'training-progress', ...
            'MaxEpochs', 10, ...
            'MiniBatchSize', 256, ...
            'CheckpointPath', temp_dir);

options_stage4 = trainingOptions('sgdm', ...
    'ExecutionEnvironment','parallel', ... % Turn on built-in parallel support.
            'InitialLearnRate', 0.001, ...
            'Plots', 'training-progress', ...
            'MaxEpochs', 10, ...
            'MiniBatchSize', 128, ...
            'CheckpointPath', temp_dir);

 options = [
     options_stage1
     options_stage2
     options_stage3
     options_stage4
     ];
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Train the Faster R-CNN. Select a BoxPyramidScale of 1.2 to allow for
% finer resolution for multiscale object detection.


temp = ['|==================================================================|', newline, ...
        '|==================================================================|', newline, ...
        '|                    TRAINING OBJECT DETECTOR                      |', newline, ...
        '|                                                                  |', newline, ...
        '|                       DO NOT CLOSE WINDOW                        |', newline, ...
        '|==================================================================|', newline, ...
        '|==================================================================|', newline];
disp(temp);


boxnet = detector

boxnet = trainFasterRCNNObjectDetector(trainingData, layers, options, ...
    'NegativeOverlapRange', [0 0.3], ...
    'PositiveOverlapRange', [0.6 1], ...
    'BoxPyramidScale', 1.2);

% TODO: SAVE THE NETWORK
save_boxnet_version = 5
boxnet_name = strcat('\\tsclient\E\FishOASIS_CNN\boxnet', '\draw_boxes_v', string(save_boxnet_version))
save(boxnet_name, boxnet);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Verify performance of the Faster R-CNN



