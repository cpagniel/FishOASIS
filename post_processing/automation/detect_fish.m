function detections = detect_fish(data_dir, index)    
    % 081018
    % Helen Cai
    % Detect fish by utilizing silhouettes and similar background imagery.
    % Accepts the data directory and index of image of interest as
    % arguments.

    % Get directory information
    old_dir = pwd;
    addpath(pwd);
    cd(data_dir);
    files = dir('*.jpg');

    % Analyze image file
    bkg = makefilter(files, index);
    name = char(files(index).name);
    fprintf(strcat(name, '\n'));
    img = imread(name);
%    figure
%    imshow(img);
    I = imsubtract(bkg, img);
%     figure
%     imshow(I);

    % Get height of image
    image_h = size(I);
    image_h = image_h(1);

    % Set red values in the lower half to 0
    I(image_h/2:end,:,1) = 0;

    % Combine RGB values to generate 1D matrix
    athresh = 85; % Subject to change
    J = I(:,:,1) + I(:,:,2) + I(:,:,3) - athresh;
    
    % Fill holes?
    J = imfill(J, 'holes');
    
    % Apply Gaussian blur
    % Higher sigma, higher blur
    J = imgaussfilt(J, .5);
    
    % Threshold value and amplify
    bthresh = 5;
    K = (J - bthresh) .^ 2;
%     figure
%     imshow(K)
    
    % Apply second Gaussian blur
    L = imgaussfilt(K, 2.5);
    
    % Threshold value without amplification
    cthresh = 30;
    L = L - cthresh;
%     figure
%     imshow(L)

    % Convert to B&W
    M = im2bw(L, graythresh(L));
    imfill(M, 'holes');

    % Remove small artifacts
    N = bwareaopen(M, 225);
%     figure
%     imshow(N)

    % Label whitespace
    P = bwlabel(N);

    % Iterate through number of labels/objects identified
    detections = [];
    k = 1;
    for j = 1:max(max(P))
        % Find coordinates where label exists in image
        [row, col] = find(P==j);
        % Get box info
        Y1 = min(row); % top
        Y1 = max(Y1-25,0); % Add some padding
        X1 = min(col); % left
        X1 = max(X1-25,0); % Add some padding
        width = max(col) - min(col); 
        height = max(row) - min(row);
        
        % Eliminate nonsense rectangles
        if width < 2 || height < 2
            continue
        % Object less than 150x150 pixels are probably artifacts
        elseif width < 151 && height < 151
            continue
        else
            detections(k,1) = X1;
            detections(k,2) = Y1;
            detections(k,3) = width + 50; % Add some padding for benefit of fishnet 
            detections(k,4) = height + 50;
            k = k + 1;
        end
    end

    % Save file
    dlmwrite(textname(files,index), detections, 'delimiter', ' ', 'newline', 'pc');

    cd(old_dir);
end