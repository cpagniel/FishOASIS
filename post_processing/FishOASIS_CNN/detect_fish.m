% 080918
% Helen Cai
% Detect fish by utilizing silhouettes and similar background imagery. 

% Get directory information
old_dir = pwd;
data_dir = uigetdir('', 'Select data folder');
cd(data_dir);
files = dir('*.jpg');


%---------------------------------------
% Iterate through image files
for i = 1:length(files)
    bkg = makefilter(files, i);
    name = char(files(i).name)
    img = imread(name);
    I = imsubtract(bkg, img);
    
    
    % Get height of image
    image_h = size(I);
    image_h = image_h(1);
    
    
    % Set red values in the lower half to 0
    I(image_h/2:end,:,1) = 0;
%     figure
%     imshow(I);
    
    % Combine RGB values
    J = I(:,:,1) + I(:,:,2) + I(:,:,3) - 85;
    % Gain values
    J = J .^ 2 - 100; % Nonlinear?
    % Convert to B&W
    K = im2bw(J, graythresh(J));
    imfill(K, 'holes');
    % Average slices and subtract
    
    % Remove small artifacts
    K = bwareaopen(K, 225);
%     figure
%     imshow(K);
    % Label whitespace
    L = bwlabel(K);
    
    % Iterate through number of labels/objects identified
    detections = [];
    k = 1;
    for j = 1:max(max(L))
        % Find coordinates where label exists in image
        [row, col] = find(L==j);
        % Get box info
        Y1 = min(row); % top
        X1 = min(col); % left
        width = max(col) - min(col) + 1;
        height = max(row) - min(row) + 1;
        
              
        % Object less than 60 pixels wide in the bottom half of the image is 
        % probably an artifact
        if width < 61 && Y1 > 0.5 * image_h
            continue
        elseif height < 61 && Y1 > 0.5 * image_h
            continue
        else
            detections(k,1) = X1;
            detections(k,2) = Y1;
            detections(k,3) = width;
            detections(k,4) = height;
            k = k + 1;
        end
    end
    
    % Save file
    dlmwrite(textname(files,i), detections, ' ');


end


% Gaussian filter?

%---------------------------------------

