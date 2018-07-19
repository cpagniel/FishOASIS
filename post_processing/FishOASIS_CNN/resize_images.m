% 071318
% Helen Cai
% From previously processed data, crop and resize previous identified
% regions of interest for training data. Modified from previous script for
% use with GUI


fprintf('Changing directories \n');

old_dir = pwd;

target_directory = strcat(handles.data_dir, '\detection_output\agree');
cd(target_directory); 


file_data = dir([pwd '/*.mat']);

fprintf('Loading data\n');
 for i = 1:length(file_data)
    current_file = file_data(i).name;

    if length(strfind(current_file, 'CallLog')) == 1 
        % Do nothing, as it is a Call Log
    else
        % Load the data from prior analysis
        load(current_file, 'DATA');


        if numel(fieldnames(DATA)) ~= 14 & numel(fieldnames(DATA)) ~= 20
        % Do nothing, as no fish were detected 
        else
            % At least one fish was detected 

            % Iterate through the total number of fish in the picture
            number_of_fish = length(DATA(1).XX1);
            for j = 1:number_of_fish
                
                % TODO: Modify the following lines based on the output of
                % the image detection network. 
                
                % Get the rectangular ROI and pass on nonsense rectangles
                if DATA(1).rect_WIDTH(j) < 1 | DATA(1).rect_HEIGHT(j) < 1
                    continue
                end

                % Redefine rectangular ROI into a square
                crop_rect = [DATA(1).XX1(j) DATA(1).YY1(j) 0 0 ]; %[X1 Y1 width height]
                if DATA(1).rect_WIDTH(j) ~= DATA(1).rect_HEIGHT(j)
                    crop_rect(3) = max(DATA(1).rect_WIDTH(j), DATA(1).rect_HEIGHT(j));
                    crop_rect(4) = max(DATA(1).rect_WIDTH(j), DATA(1).rect_HEIGHT(j));
                end

                % Crop the image into a square and resize accordingly
                fprintf('Cropping image\n');
                root_name = erase(current_file, '.mat');
                current = imread(strcat(root_name, '.jpg'));
                current_crop = imcrop(current, crop_rect);
                current_resize = imresize(current_crop, [227 227]);


               crop_name = strcat(handles.data_dir, '\resize', '\', root_name, '-', int2str(j), '.jpg');
               imwrite(current_resize, crop_name);
            end
        end
    end
 end

 cd(old_dir);
fprintf('Done\n');