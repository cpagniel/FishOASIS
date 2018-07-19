% 070218
% Helen Cai
% From previously processed data, crop and resize previous identified
% regions of interest for training data. 

function f = write_training_data(file_data)

   


    for i = 1:length(file_data)
         current_file = file_data(i).name

        if length(strfind(current_file, 'CallLog')) == 1 
            % Do nothing, as it is a Call Log
        else
            % Load the data from prior analysis
            disp("loading data")
            load(current_file, 'DATA');


            if numel(fieldnames(DATA)) ~= 14 & numel(fieldnames(DATA)) ~= 20
            % Do nothing, as no fish were detected 
            else
                % At least one fish was detected 

                % Iterate through the total number of fish in the picture
                number_of_fish = length(DATA(1).XX1);
                disp("About to iterate through fish")
                for j = 1:number_of_fish
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
                    disp('Cropping image')
                    disp(crop_rect)
                    root_name = erase(current_file, '.mat');
                    current = imread(strcat(root_name, '.jpg'));
                    current_crop = imcrop(current, crop_rect);
                    current_resize = imresize(current_crop, [227 227]);

                    % Place resized image in corresponding directory
                    current_species_number = DATA(1).rect_SCODE(j);
                    current_species_name = DATA.SFULL{current_species_number};
                    current_species_name = strrep(current_species_name, ' ', '_');
                    current_species_name = strrep(current_species_name, '(', '_');
                    current_species_name = strrep(current_species_name, ')', '_');


                   crop_name = strcat(current_species_name, '/', root_name, '-', int2str(j), '.jpg')
                   %crop_name = fullfile(pwd, current_species_name, strcat(root_name, '-', int2str(j), '.jpg'))
                   imwrite(current_resize, crop_name);
                end
            end
        end
    end
