% Helen Cai
%
% A transfer learning network created by modifying the preexisting CNN
% known as AlexNet. See the Deep Learning Onramp at Matlab Academy for
% details. 
% Modified to interface with the CNN GUI. 

disp('Loading AlexNet.')
load('alexnet.mat');
fishnet = alexnet

% Get training images by using a datastore
img_exts = {'.jpg', '.png'};

% Determine if training data has been previously processed
resize_exist = questdlg('Is there image data that has already been preprocessed and resized?',...
    '', 'Yes', 'No', 'No')
switch resize_exist
    case 'Yes'
        resize_dir = uigetdir('', 'Select folder containing resized training images. Must be called "resize"');
    case 'No'
        write_training_data
        disp('Image data has been processed.')
        resize_dir = (strcat(target_directory, '\resize'))
end

% Provide the option to eliminate certain data
% trash_exist = questdlg('Are there images that you would like to exclude from training data?',...
%     '', 'Yes', 'No', 'No')
% switch trash_exist
%     case 'Yes' 
%         trash_dir = strcat(target_directory, '\trash');
%         mkdir trash_dir
%         %trash_move = uigetfile(resize_dir, 'Select folders to exclude from training.')
%         trash_move = uigetfile('', 'Select images to exclude from training', 'MultiSelect', 'on')
%         for i = 1:length(trash_move)
%             % TODO: Fix this problem (uigetfile does not return absolute
%             % paths)
%             movefile trash_move(i) trash_dir
%         end
%     case 'No'
%         disp('Training with all images in resize directory.')
% end

% Create datastore with training data. Add additional robustness by
% shuffling and augmenting. Split the datastore into training, validation,
% and test sets. 
resize_ds = imageDatastore(resize_dir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[fishTrain, fishValidation, fishTest] = splitEachLabel(resize_ds, 0.4, 0.3, 0.3, 'randomized')
fish_names = fishTrain.Labels;
imageAugmenter = imageDataAugmenter('RandRotation',[-15 15], 'RandYReflection', 1, 'RandXTranslation', [0 10], 'RandYTranslation', [0 10]);
fishTrain = augmentedImageSource([227 227 3], fishTrain, 'DataAugmentation', imageAugmenter) % 072418


% Create a network by modifying the previous version of fishnet
layers = fishnet.Layers;

% Creates a new fully connected/output layer with n neurons.
% While there may be 91 species, there is not necessarily data available
% for each species. 

n = 9;
layers(end-2) = fullyConnectedLayer(n); 
layers(end) = classificationLayer; % This will create a new output layer for an image classification network



% Set training algorithm options
% The initial learning rate should be fine-tuned as learning goes on. As we
% are creating a transfer learning network, we will start
% training/weighting less aggressively (we only need to fine-tune the
% process). 
opts = trainingOptions('sgdm', ...
            'InitialLearnRate', 0.001, ...
            'Momentum', 0.7, ...
            'ValidationData', fishValidation,...
            'MaxEpochs', 25, ...
            'Plots', 'training-progress');


% Perform training
% trainNetwork accepts three arguments: training data, a modified training
% network, and training algorithm options.
temp = ['|==================================================================|', newline, ...
        '|==================================================================|', newline, ...
        '|                        TRAINING FISHNET                          |', newline, ...
        '|                                                                  |', newline, ...
        '|                       DO NOT CLOSE WINDOW                        |', newline, ...
        '|==================================================================|', newline, ...
        '|==================================================================|', newline];
disp(temp);
[fishnet, info] = trainNetwork(fishTrain, layers, opts);


% Save the network
save_fishnet_version = inputdlg('Enter the version # of fishnet you would like to save as.');
if isempty(save_fishnet_version)
  f = msgbox('No version number entered. Saving as default.', 'Warning', 'warn');
  save('fishnet_v', 'fishnet');
else
  save_name = strcat('fishnet_v', string(save_fishnet_version));
  save(save_name, 'fishnet', 'info');
end

% Call script to calculate performance metrics
test_set = fishTest;
current_net = fishnet;
calculate_scores