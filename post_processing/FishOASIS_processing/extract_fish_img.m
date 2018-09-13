% last update 09/12/2018
% Helen Cai/Camille Pagniello
%
% Extracts fish from images.
% Requires previously processed data with already known boxes/rectangles
% drawn in.
% Produces .jpg

old_dir = pwd;

target_directory = uigetdir('', 'Select folder containing processed images with box data.');
cd(target_directory);

save_to_dir = uigetdir('', 'Select folder to save fish images to.');

% Iterate through previously processed data
file_data = dir([pwd '/*.mat']);
disp('Iterating through file data.');
for i = 1:length(file_data)
    disp(i)
    cd(target_directory);
    current_file = file_data(i).name;
    
    if length(strfind(current_file, 'CallLog')) == 1 || length(strfind(current_file, 'box')) == 1
        % Do nothing, as it is a Call Log or other box file
    else
        % Load the data from prior analysis
        disp('Loading data')
        % set(0, 'DefaultFigureCreateFcn',@(s,e)delete(s)); % To prevent load() from creating a figure for each file
        load(current_file, 'DATA');
        
        if numel(fieldnames(DATA)) ~= 20
            % Do nothing, as no fish were detected
        else
            % At least one fish was detected
            
            % Iterate through the total number of fish in the picture
            number_of_fish = length(DATA.XX1);
            disp('About to iterate through fish')
            
            % Load corresponding image
            img = importdata([current_file(1:end-4) '.JPG']);
            
            for j = 1:number_of_fish
                
                if DATA.rect_WIDTH(j) > 0 && DATA.rect_HEIGHT(j) > 0
                    fish = imcrop(img,[DATA.XX1(j) DATA.YY1(j) DATA.rect_WIDTH(j) DATA.rect_HEIGHT(j)]);
                else
                    fish = imcrop(img,[DATA.XX1(j)+DATA.rect_WIDTH(j) DATA.YY1(j)+DATA.rect_HEIGHT(j) abs(DATA.rect_WIDTH(j)) abs(DATA.rect_HEIGHT(j))]);
                end
                    
                cd(save_to_dir);
                warning off
                mkdir(char(DATA.SCODE(DATA.rect_SCODE(j)))); cd(char(DATA.SCODE(DATA.rect_SCODE(j))));
                imwrite(fish,[current_file(1:end-4) '-' num2str(j) '.jpeg']);
                
            end
        end
    end
end

disp('Done!')