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


% Optional: read, label, and display one of the images 
I = imread(box_dataset.image_names{20});
I = insertShape(I, 'Rectangle', box_dataset.boxes{20});
I = imresize(I, 0.2);
imshow(I);

% Split the data set. Set 60% of the data for training and the rest for
% evaluation
idx = floor(0.6 * height(box_dataset));
trainingData = box_dataset(1:idx,:)
testData = box_dataset(idx:end,:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create the CNN
% The input layer defines the type and size of input. 
% For classification tasks, the input size is typically the size of the
% training images. For detection tasks, the CNN needs to analyze smaller
% sections of the image, so the input size must be similar in size to the
% smallest object int the data set. 

inputLayer = imageInputLayer([32 32 3]);

% Create the middle layers of the network. 
% The middle layers are made up of repeated blocks of convolution, ReLU,
% and pooling layers. These 3 layers form the core building blocks of CNNs.
% Define the convolutional layer parameters
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
    % Add a fully connected layer with n output neurons. 
    fullyConnectedLayer(n)
    
    % 070618
    % Add a dropout layer (a simple way to prevent overfitting)
    dropoutLayer(0.5)

    % Add a ReLU non-linearity.
    reluLayer()
    

    % Add the last fully connected layer. At this point, the network must
    % produce outputs that can be used to measure whether the input image
    % belongs to one of the object classes or background. This measurement
    % is made using the subsequent loss layers.
    fullyConnectedLayer(width(box_dataset))

    % Add the softmax loss layer and classification layer. 
    softmaxLayer()
    classificationLayer()
];


% Combine all layers
layers = [
    inputLayer
    middleLayers
    finalLayers
    ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Configure options and train the detector. 
mkdir temp
temp_dir = strcat(pwd, '\temp');

% trainFasterRCNNObjectDetector() trains the detector in 4 steps. 

% The first two steps train the region proposal and detection networks used
% in Faster R-CNN. 

options_stage1 = trainingOptions('sgdm',...
           'InitialLearnRate', 0.001, ...
           'Plots', 'training-progress',...
           'MaxEpochs', 10, ...
           'MiniBatchSize', 256, ...
           'CheckpointPath', temp_dir);

options_stage2 = trainingOptions('sgdm', ...
            'InitialLearnRate', 0.001, ...
            'Plots', 'training-progress', ...
            'MaxEpochs', 10, ...
            'MiniBatchSize', 128, ...
            'CheckpointPath', temp_dir);

% The final two steps combine the networks from the first two steps such
% that a single network is created for detection. These network weights can
% be modified more slowly than in the first two steps. 

options_stage3 = trainingOptions('sgdm', ...
            'InitialLearnRate', 0.001, ...
            'Plots', 'training-progress', ...
            'MaxEpochs', 10, ...
            'MiniBatchSize', 256, ...
            'CheckpointPath', temp_dir);

options_stage4 = trainingOptions('sgdm', ...
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




box_net = trainFasterRCNNObjectDetector(trainingData, layers, options, ...
    'NegativeOverlapRange', [0 0.3], ...
    'PositiveOverlapRange', [0.6 1], ...
    'BoxPyramidScale', 1.2);

% TODO: SAVE THE NETWORK


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Verify performance of the Faster R-CNN



