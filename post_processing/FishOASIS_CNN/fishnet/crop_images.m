% CHANGEME: Read images to resize and write into a datastore
img_names = dir('*.jpg');
mkdir resized_imgs

crop_rect = [10 10 175 200]; %[X1 Y1 width height]
for i = 1:length(img_names)
    % Redefine a rectangular crop into a square box
    x_length = crop_rect(3);
    y_length = crop_rect(4);
    
    if x_length ~= y_length
        crop_rect(3) = max(x_length, y_length);
        crop_rect(4) = max(x_length, y_length);
    end
    
    % Crop the image and resize accordingly
    current = imread(img_names(i).name);
    current_crop = imcrop(current, crop_rect);
    current_resize = imresize(current_crop, [227 227]);
    temp = strcat('resized_imgs/Resize', img_names(i).name);
    imwrite(current_resize, temp);
end
