% 070218
% Helen Cai
% A transfer learning network created by modifying the preexisting network
% known as AlexNet. See the Deep Learning Onramp at Matlab Academy for
% details. 


% TODO: Write a new neural network that draws new ROI. 

% TODO: Currently training on single CPU. GPU?

% Get training images by using a datastore
img_exts = {'.jpg', '.png'};

% TODO: Find some way to exclude images from current directory.
file_data = dir([pwd '/*.mat']);
resize_ds = imageDatastore(pwd, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
[fishTrain, fishValidation, fishTest] = splitEachLabel(resize_ds, 0.3, 0.3, 0.4, 'randomized')
fish_names = resize_ds.Labels;

% Create a network by modifying AlexNet
deepnet = alexnet;
layers = deepnet.Layers;

% Creates a new fully connected layer with n neurons.
% While there may be 91 species, there is not necessarily data available
% for each species. 
n = 10;
layers(end-2) = fullyConnectedLayer(n); 
layers(end) = classificationLayer; % This will create a new output layer for an image classification network



% Set training algorithm options
% The initial learning rate should be fine-tuned as learning goes on. As we
% are creating a transfer learning network, we will start
% training/weighting less aggressively (we only need to fine-tune the
% process). 
opts = trainingOptions('sgdm', 'InitialLearnRate', 0.001, ...
            'ValidationData', fishValidation,...
            'Plots', 'training-progress');


% Perform training
% trainNetwork accepts three arguments: training data, a modified training
% network, and training algorithm options.
disp("Training fishnet")
[fishnet, info] = trainNetwork(fishTrain, layers, opts);



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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Automate this

% Save the network
% fishnet_v0_1 = fishnet
% save fishnet_v0_1


% img1 = imread('file01.jpg');
% imshow(img1);
% pred1 = classify(deepnet, img1)
% 
% 
% [pred, scores] = classify(net, img)
% bar(scores)
% highscores = scores > 0.01
% bar(scores(highscores))
% xticklabels(categorynames(highscores))


