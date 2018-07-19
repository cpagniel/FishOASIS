% 070318
% Helen Cai
%
% Creates training data for use in draw_boxes, a Faster R-CNN used to
% detect regions of interest. 
% Requires previously processed data with already known boxes/rectangles
% drawn in. Produces a box_dataset table that contains the imageFilename and a 1x4
% double containing [XX1 YY1 width height]. 


old_dir = pwd;

target_directory = uigetdir('', 'Select folder containing processed images with box data.')
cd(target_directory); 

% Initialize variables
image_names = [];
boxes = [];
 
 
% Iterate through previously processed data
file_data = dir([pwd '/*.mat']);
fprintf("Iterating through file data.\n");
 for i = 1:length(file_data)
    current_file = string(file_data(i).name);

    if length(strfind(current_file, 'CallLog')) == 1 | length(strfind(current_file, 'box')) == 1
        % Do nothing, as it is a Call Log or other box file
    else
        % Load the data from prior analysis
        fprintf("Loading data\n")
        load(current_file, 'DATA');


        if numel(fieldnames(DATA)) ~= 14 & numel(fieldnames(DATA)) ~= 20
        % Do nothing, as no fish were detected 
        else
            % At least one fish was detected 

            % Iterate through the total number of fish in the picture
            number_of_fish = length(DATA(1).XX1);
            fprintf("About to iterate through fish\n")
            for j = 1:number_of_fish
                % Get the rectangular ROI and pass on nonsense rectangles
                if DATA(1).rect_WIDTH(j) < 1 | DATA(1).rect_HEIGHT(j) < 1
                    continue
                end
                
                
                current_box = [];
                current_box(1) = DATA(1).XX1(j);
                current_box(2) = DATA(1).YY1(j);
                current_box(3) = DATA(1).rect_WIDTH(j);
                current_box(4) = DATA(1).rect_HEIGHT(j);
                current_box = {current_box};

               

                % Append current box to list of boxes
                boxes = vertcat(boxes, current_box);

                
                % Get & append name of corresponding image
                current_name = cellstr(strcat(pwd, '\', erase(current_file, '.mat'), '.jpg'));
                image_names = vertcat(image_names, current_name);
              
             end
         end
    end
 end



% Write table to target_directory containing processed images. 
% cd(old_dir);
box_dataset = table(image_names, boxes);
save box_dataset

cd(old_dir);
