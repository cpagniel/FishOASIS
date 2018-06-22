%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Scan for Next Image
%
% Called by load_acoustics (within view_image_and_acoustics), this script
% finds the next image that has an associated audio file
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compare next audio file time to image times
% Get current audio file index
for jj = 1:length(PARAMS.afiles)
    if strcmp(PARAMS.aname,PARAMS.afiles(jj).name) % get current audio index
        break
    end
end

% Get the next audio file and load its data
PARAMS.afile = [PARAMS.afiles(jj+1).folder,'\',PARAMS.afiles(jj+1).name];
PARAMS.aname = PARAMS.afiles(jj+1).name;

DATA.AUDIO.info = audioinfo(PARAMS.afile);
[DATA.AUDIO.data DATA.AUDIO.fs] = audioread(PARAMS.afile,'native');

% Find the image that matches this data
for jj = 1:length(PARAMS.files)
    if strcmp(PARAMS.ifile,PARAMS.files(jj).name) % get current image index
        break
    end
end

% Get image filename from audio filename
BIN.starttime = datenum(PARAMS.aname(1:end-4),'yymmdd_HHMMSS') + 5/(24*60*60); % image capture time

%Scan through image file name structure for matching name
for kk = jj:length(PARAMS.files) % to start at current index and not scan already viewed images
    if strcmp([datestr(BIN.starttime,'yymmdd_HHMMSS'),'.jpg'],PARAMS.files(kk).name) 
        break % kk is the new image index
    end
end

PARAMS.ifile = PARAMS.files(kk).name;
PARAMS.ipath = [PARAMS.idir PARAMS.ifile];

% Load the image data, then draw the image and spectrogram
PARAMS.drawflag = 1; % so the spectrogram will draw
load_image
draw_image
draw_specgram
