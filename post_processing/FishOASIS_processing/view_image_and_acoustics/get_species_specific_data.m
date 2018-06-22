%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get Species-specific Data
%
% Called by view_image_and_acoustics, this script grabs the data associated
% with a species (or group) of interest. It uses the output from
% analyze_fish_count_data to find only the images where the species was
% seen, and the acoustics associated with those images.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DLG.quest = 'Load images associated with specific species?';
    DLG.ttl = 'Load Images'; DLG.btn1 = 'Yes'; DLG.btn2 = 'No';
    DLG.choice = questdlg(DLG.quest,DLG.ttl,DLG.btn1,DLG.btn2,DLG.btn2);
    
    if strcmp(DLG.choice,DLG.btn1)
        [PARAMS.spfile PARAMS.sppath] = uigetfile('*.mat','Select species data file');
        if PARAMS.spfile ~= 0
            load([PARAMS.sppath PARAMS.spfile]);
            PARAMS.spflag = 1;
        else
            uiwait(msgbox('User canceled file selection. All images will be loaded'));
            PARAMS.spflag = 0;
        end
    else
        PARAMS.spflag = 0;
    end