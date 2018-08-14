% A transfer learning network created by modifying the preexisting CNN
% known as AlexNet. Generates a .mat file containing information for the trained
% network.

% Determine if training data exists
resize_exist = questdlg('Is there image data that has already been preprocessed and resized?',...
    '', 'Yes', 'No', 'No');
switch resize_exist
    case 'Yes'
        resize_dir = uigetdir('', 'Select folder containing resized training images.');
    case 'No'
        fprintf('Stopped: detect images first.\n')
end

% Create datastore with training data. Add additional robustness by
% shuffling and augmenting. Split the datastore into training, validation,
% and test sets. 
resize_ds = imageDatastore(resize_dir, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[fishTrain, fishValidation, fishTest] = splitEachLabel(resize_ds, 0.4, 0.3, 0.3, 'randomized');
fish_names = fishTrain.Labels;
imageAugmenter = imageDataAugmenter('RandRotation',[-15 15], 'RandYReflection', 1, 'RandXTranslation', [0 10], 'RandYTranslation', [0 10]);
fishTrain = augmentedImageSource([227 227 3], fishTrain, 'DataAugmentation', imageAugmenter);

% Load AlexNet
alexnet = alexnet();

% Creates a new fully connected/output layer with n neurons, where 
% n = number of classes
layers = alexnet.Layers;
n = 9;
layers(end-2) = fullyConnectedLayer(n); 
layers(end) = classificationLayer; 

% Set training algorithm options
% The initial learning rate should be fine-tuned as learning goes on. As we
% are creating a transfer learning network, we will start
% training/weighting less aggressively.

opts = trainingOptions('sgdm', ...
            'InitialLearnRate', 0.001, ...
            'Momentum', 0.7, ...
            'ValidationData', fishValidation,...
            'MaxEpochs', 25, ...
            'Plots', 'training-progress');

% Perform training
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