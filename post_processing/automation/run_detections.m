% 081218
% Master script integrating image detection (using detect_fish) and image
% classification (using fishnet). 
% Generates one text file for each raw image. 

% Classes of detection that fishnet has been trained on. Should correspond
% with those listed in classes.txt.
classes = categorical({'blacksmith' 'flora' 'garibaldi' 'halfmoon' 'kelp' ...
    'kelp_bass' 'line' 'sheephead' 'unknown'});

% Get file directory of raw data
fprintf('Select folder containing raw images\n');
data_dir = uigetdir('', 'Select folder containing raw images');

% Get classification network of choice
fprintf('Select classification network.\n');
[network, pathname] = uigetfile('*.mat', 'Select classification network.');
load(strcat(pathname, network));
fprintf('Loaded detection network: ');
fprintf(network);

% Run detections on each image
fprintf('\nRunning detection on images: \n');
n_images = size(dir([fullfile(data_dir), '\*.jpg']));
n_images = n_images(1);
for i = 1:n_images
    detect_fish(data_dir, i);
end

% Run classification on each image
files = dir([fullfile(data_dir), '\*.jpg']);
for i = 1:n_images
    
    % Read image
    I = imread(files(i).name);
    
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
            rect = dtns(j,:);
            rect(3) = max(rect(3), rect(4));
            rect(4) = max(rect(3), rect(4));
            J = imcrop(I, rect);
            J = imresize(J, [227 227]);
            pred = classify(fishnet, J);
            fprintf(strcat(string(pred), '\n'));
            
            % Add species code
            [C, index] = intersect(cats, pred);
            dtns(j,5) = index;
        end
        
        % Write contents of file back in
        % Each row is formatted as:
        %       [left coordinate] [top coordinate] [width] [height] [class code]
        dlmwrite( textname(files,i), dtns, ' ');
        
    end
    
end

fprintf('Done with detection & classification. \n');
fprintf('Check text files for results. \n');