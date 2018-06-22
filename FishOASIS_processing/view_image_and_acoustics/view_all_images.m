%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% View All Images
%
% Called by view_image_and_acoustics, this script loads all the images
% within a directory(s), as well as the associated acoustics.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isfield(PARAMS,'imdir')
    % Select the directory(s) that contain the image files
    uiwait(msgbox('Select image directory'));
    
    BIN.a = 1;
    BIN.gdir = uigetdir('','Select image directory');
    
    if BIN.gdir ~= 0
        PARAMS.imdir{BIN.a}.files = dir([BIN.gdir,'\*.jpg']);
        PARAMS.adir{BIN.a}.files = dir([BIN.gdir,'\*.wav']);
    else
        close(MAIN.hf1); close(MAIN.hf2);
        clear all global;
        uiwait(msgbox('User canceled directory selection - program terminates'));
        return
    end
    
    DLG.quest = 'Select another image directory?'; DLG.ttl = 'Select another directory';
    DLG.btn1 = 'Yes'; DLG.btn2 = 'No';
    DLG.choice = questdlg(DLG.quest,DLG.ttl,DLG.btn1,DLG.btn2,DLG.btn1);
    
    while strcmp(DLG.choice,DLG.btn1)
        BIN.a = BIN.a+1;
        BIN.gdir = uigetdir(BIN.gdir,'Select directory');
        PARAMS.imdir{BIN.a}.files = dir([BIN.gdir,'\*.jpg']);
        PARAMS.adir{BIN.a}.files = dir([BIN.gdir,'\*.wav']);
        DLG.choice = questdlg(DLG.quest,DLG.ttl,DLG.btn1,DLG.btn2,DLG.btn1);
    end
    
    PARAMS.files = [];
    for ii = 1:length(PARAMS.imdir)
        PARAMS.files = [PARAMS.files;PARAMS.imdir{ii}.files];
    end
    
    PARAMS.afiles = [];
    for ii = 1:length(PARAMS.adir)
        PARAMS.afiles = [PARAMS.afiles;PARAMS.adir{ii}.files];
    end
    
    uiwait(msgbox(['Select an image file to view.'...
        'Click cancel on the next pop-up to load the first image in the series.']));
    
end

if ~isfield(PARAMS,'ifile')
    
    [PARAMS.ifile,PARAMS.idir] = uigetfile([PARAMS.imdir{1}.files(1).folder '\*.jpg'],'Select Image File');
    
    if PARAMS.ifile ~= 0
        
        PARAMS.ipath = [PARAMS.idir PARAMS.ifile];
        
    else
        
        PARAMS.ifile = PARAMS.imdir{1}.files(1).name;
        PARAMS.idir = [PARAMS.imdir{1}.files(1).folder,'\'];
        PARAMS.ipath = [PARAMS.idir PARAMS.ifile];
        
    end
    
else
    
    PARAMS.ipath = [PARAMS.idir PARAMS.ifile];
    
end
