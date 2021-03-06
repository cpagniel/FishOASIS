% 081218
% Master script integrating image detection (using detect_fish) and image
% classification (using fishnet). 
% Generates one text file for each raw image. 

% Change these boolean flags as needed
TRAIN = 1;
DETECT = 1;
CLASSIFY = 1;
COUNT = 1;

diary('log.txt');
fprintf(strcat(string(datetime), '\n'));

% Classes of detection that fishnet has been trained on. Should correspond
% with those listed in classes.txt.
classes = categorical({'blacksmith' 'flora' 'garibaldi' 'halfmoon' 'kelp' ...
    'kelp_bass' 'line' 'sheephead' 'unknown'});

% Get file directory of raw data
fprintf('Select folder containing raw images.\n');
data_dir = uigetdir('', 'Select folder containing raw images.');
fprintf('Loading images from ');
fprintf('%s', data_dir);

% Change directories
addpath(pwd);
addpath('./fishnet');
old_dir = pwd;
cd(data_dir);

% Train network if necessary
if TRAIN
    fprintf('\nTraining new classification network.\n');
    train_classifier
end

% Get classification network of choice
fprintf('\nSelect classification network.\n');
[network, pathname] = uigetfile('*.mat', 'Select classification network.');
load(strcat(pathname, network));
fprintf('Loaded detection network: ');
fprintf(network);

% Run detections on each image
if DETECT
    fprintf('\nRunning detection on images: \n');
    n_images = size(dir([fullfile(data_dir), '\*.jpg']));
    n_images = n_images(1);
    for i = 1:n_images
        detect_fish(data_dir, i);
    end
end

% Run classification on each image
if CLASSIFY
    fprintf('Classifying detections.\n');
    files = dir([fullfile(data_dir), '\*.jpg']);
    n_images = size(files);
    for i = 1:n_images(1)

        % Read image
        I = imread(files(i).name);
        fprintf(strcat(files(i).name, '\n'));

        % Read contents of corresponding text file
        fileID = fopen( textname(files,i), 'r+'); % check permissions here
        dtns = fscanf(fileID, '%d', [4, inf])' ;
        fclose(fileID);

        % Check if the file is empty
        if isempty(dtns)
            continue
        else
            % Iterate through each detection
            s = size(dtns);
            for j = 1:s(1)
                % Crop and resize image for classification
                rect = dtns(j,1:4);
                rect(3) = max(rect(3), rect(4));
                rect(4) = max(rect(3), rect(4));
                J = imcrop(I, rect);
                J = imresize(J, [227 227]);
                pred = classify(fishnet, J);
                fprintf(strcat(string(pred), '\n'));

                % Add species code
                [C, index] = intersect(classes, pred);
                dtns(j,5) = index;
            end

            % Write contents of file back into text file
            % Each row is formatted as:
            %       [left coordinate] [top coordinate] [width] [height] [class code]
            dlmwrite( textname(files,i), dtns, ' ');

        end
    end
fprintf('Done with detection & classification. \n');
fprintf('Check text files for results. \n');
end

diary off;

if COUNT
    % Count instances of fish using the log
    fprintf('\nCounting instances of fish using log. \n');
    fileID = fopen( 'log.txt', 'r');
    T = textscan(fileID, '%s');
    fclose(fileID);
    T = strjoin(string(T{1,1}));
    for i = 1:length(classes)
        c = string(classes(i));
        counts.(c) = count(T, c);
    end
    counts = struct2table(counts);
    writetable(counts);
    fprintf('Counts saved to counts.txt.\n')
end

fprintf('End of script.\n')
cd(old_dir);