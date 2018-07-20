%% Pull out data from image analysis
% This script pulls out the fish count and identity data from the MAT files
% created by the image_processing program and saves it as a sinlge MAT file.
%
% Author: J Butler
% Created: Dec 2017
% Last Edit: Jan 2018 by J Butler
% Edit comments: Fixed an error that created an incorrect time stamp on the
% data and prevented the count data from being associated back to the
% correct image

%% Get the directory where the files are located
a = 1;
gdir = uigetdir('','Select the directory containing the image analysis files');

if gdir ~= 0
    day{a}.files = dir([gdir,'\','*.mat']);
else
    uiwait(msgbox('User canceled directory selection - program terminates'));
    return
end

quest = 'Select another directory to load?'; ttl = 'Load directories';
btn1 = 'Yes'; btn2 = 'No';
choice = questdlg(quest,ttl,btn1,btn2,btn1);

while strcmp(choice,btn1)
    a = a+1;
    gdir = uigetdir(gdir,'Select directory');
    day{a}.files = dir([gdir,'\','*.mat']);
    choice = questdlg(quest,ttl,btn1,btn2,btn1);
end

%% Loop through the files structure, load each file, pull out the necessary
% data, and clear the file. All files combined would be too large to load
% at once.

set(0, 'DefaultFigureCreateFcn',@(s,e)delete(s)); % To prevent load() from creating a figure for each file

for h = 1:numel(day)
    d{h} = ['day' num2str(h)];
    
    for i = 1:numel(day{h}.files)
        
        if strfind(day{h}.files(i).name,'CallLog')
            continue
        else
            
            load([day{h}.files(i).folder,'\',day{h}.files(i).name],'DATA');
            
            iDATA.(d{h}).date(i,1) = datenum(DATA.FILENAME(1:13),'yymmdd_HHMMSS');
            
            max_snumb = 94; % as of 07052018
            
            if length(DATA.COUNT) == 76
                iDATA.(d{h}).count(i,:) = [DATA.COUNT,zeros(1,max_snumb-76)];
            end
            
            if length(DATA.COUNT) == 79
                iDATA.(d{h}).count(i,:) = [DATA.COUNT,zeros(1,max_snumb-79)];
            end
            
            if length(DATA.COUNT) == 91
                iDATA.(d{h}).count(i,:) = [DATA.COUNT,zeros(1,max_snumb-91)];
            end
            
            if i == numel(day{h}.files)
                iDATA.(d{h}).species = load('species.mat','snumb')';
            end
            
            clear DATA
            
        end
        
    end
end

set(0, 'DefaultFigureCreateFcn',''); % Allows figures to be created again

%% Save the data
quest = 'Would you like to save the extracted count data?';
ttl = 'Save data'; btn1 = 'Yes'; btn2 = 'No';
choice = questdlg(quest,ttl,btn1,btn2,btn1);

if strcmp(choice,btn1)
    [sname spath] = uiputfile('*.mat','Save extracted count data');
    if isequal(sname,0) || isequal(spath,0)
        uiwait(msgbox('User cancelled save request'));
        return
    else
        cd(spath);
        save(sname,'iDATA','-mat','-v7.3');
        cd(gdir);
    end
else
    uiwait(msgbox('User elected not to save extracted count data'));
    return
end