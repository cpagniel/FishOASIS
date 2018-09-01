function detections = detector(data_dir, index)  
    % Helen Cai
    % Detect fish by utilizing silhouettes and similar background imagery.
    % Accepts the data directory and index of image of interest as
    % arguments.

    % Get directory information
    files = dir('*.jpg');

    % Analyze image file
    bkg = makefilter(files, index);
    name = char(files(index).name);
    fprintf(strcat(name, '\n'));
    img = imread(name);
%     figure
%     imshow(img);
    I = imsubtract(bkg, img);
%     imtool(I);

    % Stretch contrast
    I = imadjust(I, ...
        [0.20, 0.03, 0.03; 0.27, 0.27, 0.27], [0, 0.75]);
%     figure
%     imshow(I);
    
    % Segment color layers and threshold
    red_thresh = 0.25;
    green_thresh = 0.15;
    blue_thresh = 0.20;
    
    I(:,:,1) = I(:,:,1) - red_thresh;
    I(:,:,2) = I(:,:,2) - green_thresh;
    I(:,:,3) = I(:,:,3) - blue_thresh;
   
    % Generate 1D matrix
    J = rgb2gray(I);
    J = imfill(J, 'holes');
%     figure
%     imshow(J)
    
    % Apply Gaussian blur
    % Higher sigma, higher blur
    J = double( imgaussfilt(J, .25) );
%     figure
%     imshow(J)
    
    % Threshold value and amplify by sigmoid
    s = abs(4 - ( J ./ 32 ) );
    t = exp(s) ./ ( exp(s) + 1);
    K = uint8( J.*t );
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
end