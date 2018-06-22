%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Load Acoustics
%
% Called by view_image_and_acoustics to load in the correct acoustic file
% for a given image, if those acoustics data exist
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Compare length of PARAMS.files and PARAMS.afiles
% If they are the same length, then the image index and acoustic index will
% match up 1-to-1
if length(PARAMS.files) == length(PARAMS.afiles)
    
    for ii=1:length(PARAMS.files) % ii will be the index
        if strcmp(PARAMS.ifile,PARAMS.files(ii).name)
            break
        end
    end
    
    PARAMS.afile = [PARAMS.afiles(ii).folder,'\',PARAMS.afiles(ii).name];
    PARAMS.aname = PARAMS.afiles(ii).name;
    
    DATA.AUDIO.info = audioinfo(PARAMS.afile);
    [DATA.AUDIO.data DATA.AUDIO.fs] = audioread(PARAMS.afile,'native');
    
end

%% If lengths don't match, need to do some finagling

if length(PARAMS.files) ~= length(PARAMS.afiles)
    % Time the image was taken
    PARAMS.itime = datenum(PARAMS.ifile(1:end-4),'yymmdd_HHMMSS');
    PARAMS.starttime = PARAMS.itime - 5/(24*60*60); % to get audio file start time
    
    for ii=1:length(PARAMS.afiles) % ii will be the index
        if strcmp([datestr(PARAMS.starttime,'yymmdd_HHMMSS'),'.wav'],PARAMS.afiles(ii).name)
            break
        end
    end
    
    if strcmp([datestr(PARAMS.starttime,'yymmdd_HHMMSS'),'.wav'],PARAMS.afiles(ii).name)
        % sanity check to make sure the for loop above just doesn't spit out the max value for ii
        
        PARAMS.afile = [PARAMS.afiles(ii).folder,'\',PARAMS.afiles(ii).name];
        PARAMS.aname = PARAMS.afiles(ii).name;
        
        DATA.AUDIO.info = audioinfo(PARAMS.afile);
        [DATA.AUDIO.data DATA.AUDIO.fs] = audioread(PARAMS.afile,'native');
        
    else
        DLG.quest = ...
            'No audio exists for this image. Select another image, or scan for next image with audio?';
       DLG.ttl = 'No concurrent audio'; 
        DLG.btn1 = 'Select Image'; DLG.btn2 = 'Scan for Image'; DLG.btn3 = 'Display without audio';
        DLG.choice = questdlg(quest,ttl,btn1,btn2,btn3,btn2);
        
        if strcmp(DLG.choice,DLG.btn1)
            openimage
        elseif strcmp(DLG.choice,DLG.btn2)
            scan_for_next_image
        else
            PARAMS.drawflag = 0;
            uiwait(msgbox('Image will display without audio'));
            return
        end
    end
end