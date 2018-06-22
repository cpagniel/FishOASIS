%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% View Subset of Images
%
% Called by view_image_and_acoustics, this script allows the user to view
% only those images that contain species of interest.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Select the directory(s) that contain the image files
uiwait(msgbox('Select image directory'));

BIN.a = 1;
BIN.gdir = uigetdir('','Select image directory');

if BIN.gdir ~= 0
    PARAMS.spdir{BIN.a}.files = dir([BIN.gdir,'\*.jpg']);
    PARAMS.aspdir{BIN.a}.files = dir([BIN.gdir,'\*.wav']);
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
    PARAMS.spdir{BIN.a}.files = dir([BIN.gdir,'\*.jpg']);
    PARAMS.aspdir{BIN.a}.files = dir([BIN.gdir,'\*.wav']);
    DLG.choice = questdlg(DLG.quest,DLG.ttl,DLG.btn1,DLG.btn2,DLG.btn1);
end

% Iterate through the file names and pull out the ones that match
% spDATA.ifiles is the list of images for species of interest
PARAMS.sublist = spDATA.ifiles;

% Create structure containing info for all image files in directory(s)
PARAMS.ifilesall = [];
for ii = 1:length(PARAMS.spdir)
    for jj = 1:length(PARAMS.spdir{ii}.files)
        PARAMS.ifilesall = [PARAMS.ifilesall;PARAMS.spdir{ii}.files(jj)];
    end
end

% Create a list of all image file names within the directory
PARAMS.allfileslist = cell(size(PARAMS.ifilesall));
for ii = 1:length(PARAMS.ifilesall)
    PARAMS.allfileslist{ii}= PARAMS.ifilesall(ii).name;
end

% Find where those lists match
[~,BIN.idxs] = intersect(PARAMS.allfileslist,PARAMS.sublist,'stable');

PARAMS.files = PARAMS.ifilesall(BIN.idxs);

PARAMS.ifile = PARAMS.files(1).name; PARAMS.idir = [PARAMS.files(1).folder '\'];
PARAMS.ipath = [PARAMS.idir PARAMS.ifile];


% Acoustics
% Need to load only the acoustic files for the selected images
for ii = 1:length(PARAMS.files)
    PARAMS.itime(ii) = datenum(PARAMS.files(ii).name(1:end-4),'yymmdd_HHMMSS');
    PARAMS.starttime(ii) = PARAMS.itime(ii) - 5/(24*60*60); % to get audio file start time
end

PARAMS.afilesall = [];
for ii = 1:length(PARAMS.aspdir)
    for jj = 1:length(PARAMS.aspdir{ii}.files)
        PARAMS.afilesall = [PARAMS.afilesall;PARAMS.aspdir{ii}.files(jj)];
    end
end

% Create a list of filenames for the WAVs that we want to keep
for ii = 1:length(PARAMS.starttime)
    PARAMS.alist{ii} = [datestr(PARAMS.starttime(ii),'yymmdd_HHMMSS'),'.wav'];
end

% Create a list of all WAV files within the directory
PARAMS.blist = cell(size(PARAMS.afilesall));
for ii = 1:length(PARAMS.afilesall)
    PARAMS.blist{ii}= PARAMS.afilesall(ii).name;
end

% Find where those lists match
[~,BIN.idxs] = intersect(PARAMS.blist,PARAMS.alist,'stable');

PARAMS.afiles = PARAMS.afilesall(BIN.idxs);

% Set PARAMS.spflag == 3 to prevent this from running again
PARAMS.spflag = 3;