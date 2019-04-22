% 
% The program will read files from .xls format and change the values in the
% image's .mat file
%
% To save data in the .xls format:
%           In the first column, put the image files names
%                   e.g. 170929_185154
%           In the following columns, put the new fish ID codes in their
%           respective order (can be done by looking at the fish folders of
%           the finished processsed data set).
%                  -For deleting an entry, write a 0
%                  -To keep the original entries, leave blank

%% open .xls file
clear

fprintf('*** Welcome to the fish changer program! ***\n');
prompt = 'Enter the .xlsx file';
[filename,pathname] = uigetfile('.xlsx',prompt);
cd(pathname)
[num, txt, data] = xlsread(filename);
fishID_data = data(:, 2:size(data,2));
image_data = data(:,1);

%% find image locations

for i = 1:size(data,1)
    image_full = strcat('20', image_data{i});
    image_date = strtok(image_full, '_');
    image_edit = strcat(image_date, ' - Edited');
    image_path(:,:,i) = strcat('E:\2017_Camera_Data\2017\September-October\Edited\', image_edit, '\', image_data{i,1}, '.mat');
    image_copy(:,:,i) = strcat('E:\2017_Camera_Data\2017\September-October\Edited\', image_edit, '\edit\', image_data{i,1}, '_copy.mat');
end

%% change values

for i = 1:size(data,1)
    load(image_path(:,:,i));
    close all
    % copy files
    copyfile(image_path(:,:,i),image_copy(:,:,i));
    
    fprintf('\n%s:\n', strcat(image_data{i},'.mat'));
    
    % find elements to change
    for j = 1:size(fishID_data,2)
        nan_array = cellfun(@isnan,fishID_data,'uni',false);
        if nan_array{i,j} == 1 
            j = j+1;
        elseif fishID_data{i,j} == 0
            DATA.XXc(j) = [];
            DATA.XX1(j) = [];
            DATA.XX2(j) = [];
            DATA.YY1(j) = [];
            DATA.YY2(j) = [];
            DATA.rect_SCODE(j) = [];
            DATA.rect_WIDTH(j) = [];
            DATA.rect_HEIGHT(j) = [];
            fprintf('\tSelection number %d deleted\n', j')
        else
            old_value = DATA.rect_SCODE(1,j);
            DATA.rect_SCODE(1,j) = fishID_data{i,j};
            fprintf('\t%d changed to %d\n', old_value, DATA.rect_SCODE(1,j))
        end
    end
    save(image_path(:,:,i),'DATA','MAIN','PARAMS');
end
clear




   




