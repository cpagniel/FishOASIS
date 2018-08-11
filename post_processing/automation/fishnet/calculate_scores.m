% Helen Cai
% 072318
% Calculate performance metrics for neural networks of interest
% Called directly from scripts defining training for boxnet/fishnet



% Use trained network to classify test images
fprintf("Classifying data using test set\n")
current_net.Layers
preds = classify(current_net, test_set)


% Plot training loss
% figure
% plot(info.TrainingLoss);
% title('fishnet training loss');

% Investigate the percentage correct
disp('Number of correct guesses: ')
disp( nnz(preds == test_set.Labels))
disp('Percentage of correct guesses: ')
disp( nnz(preds == test_set.Labels) / numel(preds))

% Calculate confusion matrix
% The (j,k) element of the confusion matrix is a count of how many images
% from class j the network predicted to be in class k. Hence, diagonal
% elements represent correct classifications; off-diagonal elements
% represent misclassifications. 
fprintf("Calculating confusion matrix...\n")
[confusion_matrix, names] = confusionmat(test_set.Labels, preds);
heatmap(names, names, confusion_matrix);

% Calculate classifications scores.
% Store as multidimensional array. 
classification_scores = zeros(1, length(names), 6);
for i = 1:length(names)
    j = i-1;
    k = i+1;
    
    % True positive in page 1
    tp = confusion_matrix(i, i);
    classification_scores(1, i, 1) = tp;
    
    % True negative in page 2
    classification_scores(1, i, 2) = sum(sum(confusion_matrix(1:j, 1:j))) ...
        + sum(sum(confusion_matrix(1:j, k:end))) ...
        + sum(sum(confusion_matrix(k:end, 1:j))) ...
        + sum(sum(confusion_matrix(k:end, k:end)));
    
    % False negative in page 3
    fn = sum(sum(confusion_matrix(i, 1:j))) ...
        + sum(sum(confusion_matrix(i, k:end)));
    classification_scores(1, i, 3) = fn;
    
    % False positive in page 4
    fp = sum(sum(confusion_matrix(1:j, i))) ...
        + sum(sum(confusion_matrix(k:end, i)));
    classification_scores(1, i, 4) = fp;
    
    % Precision in page 5
    if isnan(tp / (tp + fp));
        classification_scores(1, i, 5) = 0;
    else
        classification_scores(1, i, 5) = tp / (tp + fp);
    end
    
    % Recall in page 6
    if isnan(tp / (tp + fn));
        classification_scores(1, i, 6) = 0;
    else
        classification_scores(1, i, 6) = tp / (tp + fn);
    end
    
end
clear tp fp fn

classification_scores

% Display relevant scores
disp('Precision: ')
precision = mean(classification_scores(:, :, 5));
disp(precision)
disp('Recall: ')
recall = mean(classification_scores(:, :, 6));
disp(recall)
disp('F1 score (the closer to 1, the better): ')
disp( 2 * precision * recall / (precision + recall) )

