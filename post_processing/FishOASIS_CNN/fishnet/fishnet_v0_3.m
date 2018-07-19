% Helen Cai
%
% A transfer learning network created by modifying the preexisting CNN
% known as AlexNet. See the Deep Learning Onramp at Matlab Academy for
% details. 
% Modified to interface with the CNN GUI. 

disp('Loading brand-new transfer network.')
fishnet = alexnet;

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
[fishTrain, fishValidation] = splitEachLabel(resize_ds, 0.6, 0.4, 'randomized')
fish_names = fishTrain.Labels;
fishTrain = augmentedImageSource([227 227 3], fishTrain); % 070618


% Create a network by modifying the previous version of fishnet
layers = fishnet.Layers;

% Creates a new fully connected/output layer with n neurons.
% While there may be 91 species, there is not necessarily data available
% for each species. 

n = 13;
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
  save(fishnet_v, 'fishnet');
else
  save_name = strcat('fishnet_v', string(save_fishnet_version));
  save(save_name, 'fishnet');
end

fishTest = fishValidation;

% Use trained network to classify test images
disp("Classifying data using fishnet")
preds = classify(fishnet, fishTest)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Evaluate performance by plotting training loss
figure
plot(info.TrainingLoss);
title('fishnet training loss');

% Investigate the percentage correct
disp('Number of correct guesses: ')
disp( nnz(preds == fishTest.Labels))
disp('Percentage of correct guesses: ')
disp( n_correct / numel(preds))

% Calculate confusion matrix
% The (j,k) element of the confusion matrix is a count of how many images
% from class j the network predicted to be in class k. Hence, diagonal
% elements represent correct classifications; off-diagonal elements
% represent misclassifications. 
disp("Calculating confusion matrix...")
[confusion_matrix, temp] = confusionmat(fishTest.Labels, preds);
heatmap(temp, temp, confusion_matrix)



% TODO: Wait for more data to continue training fish classification.
% TODO: Improve performance by adjusting learning rates/momentum
% TODO: Test and rectify overfitting 
