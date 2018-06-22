%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% grab_acoustics.m
%
% This script is meant for use with the FishOASIS acoustic-optical recorder
% set-up. It reads in the timestamps of the images captured by FishOASIS
% and pulls out the acoustic data for the same time period. Additionally,
% user can choose to filter the timestamps to only timestamps associated with a
% particular species or multiple species to limit the extracted acoustics
% to just those times (to help associate specific calls with specific
% species). User will have the option to plot the image and
% acoustics for visual inspection.
%
% Author: J Butler
% Created: Jan 2018
% Edited: Jan 2018 by J Butler
%         Jun 2018 J Butler - add safeguard in case there are no errors @
%         line 558
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Clean up workspace
quest = 'Command window and all variables will be cleared';
ttl = 'Clean up workspace'; btn1 = 'Ok'; btn2 = 'Cancel';
choice = questdlg(quest,ttl,btn1,btn2,btn1);

if strcmp(choice,btn1)
    clear
    clc
else
    msgbox('User canceled scipt');
    return
end

%% Select image and acoustic directories
t1 = tic;
disp(['Script initiated at: ',datestr(now)]);

choice = questdlg('Select the directory of the image and audio files', 'Select Directory', 'OK', 'Cancel','OK');

if strcmp(choice, 'Cancel')
    msgbox('User canceled script');
    return
end
a = 1;
b = 1;
d = {['d',num2str(a)]};

ifilesdir = uigetdir('','Select image files directory');%The folder where the images are
afilesdir = uigetdir('','Select audio files directory');%the folder where the audio files are

if ifilesdir(1) == 0 || afilesdir(1) == 0
    errordlg('User selected cancel. Script exits.')
    clear
    return
end

ifiles.(d{1}) = dir(strcat(ifilesdir,'\*.jpg'));%structure containing info about image files
afiles.(d{1}) = dir(strcat(afilesdir,'\*.wav'));%structure conatining info about audio files

quest = 'Select another image or audio directory to load?'; ttl = 'Load directories';
btn1 = 'Images'; btn2 = 'Audio'; btn3 = 'None';
choice = questdlg(quest,ttl,btn1,btn2,btn3,btn3);


 while strcmp(choice,btn1) || strcmp(choice,btn2)
        while strcmp(choice,btn1)
            a = a+1;
            d = {['d',num2str(a)]};
            ifilesdir = uigetdir(ifilesdir,'Select image files directory');
            ifiles.(d{1}) = dir([ifilesdir,'\*.jpg']);
            choice = questdlg(quest,ttl,btn1,btn2,btn3,btn3);
        end
    
        while strcmp(choice,btn2)
            b = b+1;
            d = {['d',num2str(b)]};
            afilesdir = uigetdir(afilesdir,'Select audio files directory');
            afiles.(d{1}) = dir([afilesdir,'\*.wav']);
            choice = questdlg(quest,ttl,btn1,btn2,btn3,btn3);
        end
end

% Check the structures
if isempty(ifiles)
    errordlg('The selected image directory did not contain .JPG images. Please select a driectory containing JPGs.','Image Directory Error');
    ifilesdir = uigetdir(ifilesdir,'Select image files directory');
    ifiles = dir(strcat(ifilesdir,'\*.jpg'));
end

if isempty(afiles)
    errordlg('The selected audio directory did not contain .WAV audio. Please select a driectory containing WAVs.','Audio Directory Error');
    afilesdir = uigetdir(afilesdir,'Select audio files directory containing WAVs');
    afiles = dir(strcat(afilesdir,'\*.wav'));
end

% determine whether audio files were decimated
dec = questdlg('Were audio files decimated?','','Yes','No','No');
if strcmp(dec,'Yes')
    dflag = 1;
else
    dflag = 0;
end

%% Calculate image capture times and audio file start times
% Images
for ii = 1:length(fieldnames(ifiles))
    d = {['d',num2str(ii)]};
    for jj = 1:length(ifiles.(d{1}))
        fname = ifiles.(d{1})(jj).name;
        ifiles.(d{1})(jj).itime = datenum(fname(1:end-4),'yymmdd_HHMMSS');
    end
    clear d
end
        
% Audio 
for ii = 1:length(fieldnames(afiles))
    d = {['d',num2str(ii)]};
    for jj = 1:length(afiles.(d{1}))
        fname = afiles.(d{1})(jj).name;
        if dflag == 1
            afiles.(d{1})(jj).atime = datenum(fname(12:end-8),'yymmddHHMMSS');
        else
            afiles.(d{1})(jj).atime = datenum(fname(12:end-4),'yymmddHHMMSS');
        end
    end
    clear d
end

%% Load processed image data
quest = 'Would you like to load fish count data, if it exists?';
ttl = 'Load Count Data';
btn1 = 'Yes'; btn2 = 'No';
choice = questdlg(quest,ttl,btn1,btn2,btn1);

if strcmp(choice,btn1)
    % Check to see if the processed data exists
    for ii = 1:length(fieldnames(ifiles))
        d = {['d',num2str(ii)]};
        mfiles.(d{1}) = dir([ifiles.(d{1})(1).folder,'\','*.mat']);
        mlog(ii) = ~isempty(mfiles.(d{1})); % logical stating whether the struct is empty
    end
    
    if any(mlog)
        % Loop through the files structure, load each file, pull out the necessary
        % data, and clear the file. All files combined would be too large to load
        % at once.
        
        set(0, 'DefaultFigureCreateFcn',@(s,e)delete(s)); % To prevent load() from creating a figure for each file
        
        for h = 1:length(fieldnames(mfiles))
            d{h} = ['d' num2str(h)];
            
            for i = 1:numel(mfiles.(d{h}))
                
                load([mfiles.(d{h})(i).folder,'\',mfiles.(d{h})(i).name],'DATA');
                
                mfiles.(d{h})(i).count = DATA.COUNT;
                
                if i == numel(mfiles.(d{h}))
                    mfiles.species = DATA.SFULL;
                end
                
                clear DATA
                
            end
        end
        mflag = 1;
        set(0, 'DefaultFigureCreateFcn',''); % Allows figures to be created again
    else
        uiwait(msgbox('No processed image data exits. Press OK to continue.'));
        mflag = 0;
    end
    
elseif strcmp(choice,btn2)
    uiwait(msgbox('Processed image data will not be loaded. Press OK to continue.'));
        mflag = 2;
end

%% Determine whether to pull out acoustic data for every image, or just images
% that contain specific fish species
for ii = 1:length(fieldnames(afiles))
    adir = {['d',num2str(ii)]};
    for jj = 1:length(afiles.(adir{1}))
        afiles.(adir{1})(jj).info = audioinfo([afiles.(adir{1})(jj).folder,'\',afiles.(adir{1})(jj).name]);
    end
end

errorlog.count = 0; % for error indexing

if mflag == 0
    
    uiwait(msgbox(['No fish count data exists for these images.',...
        ' Acoustic data will be extracted for all images.']));
    
    % Permute each image file time on acoustic file start times to
    % find the WAV that will contain the correct image time.
    for ii = 1:length(fieldnames(ifiles))
        d{ii} = ['d' num2str(ii)];
        for jj = 1:length(ifiles.(d{ii}))
            for kk = 1:length(fieldnames(afiles))
                adir = {['d',num2str(kk)]};
                for ll = 1:length(afiles.(adir{1}))
                    if afiles.(adir{1})(ll).atime < ifiles.(d{ii})(jj).itime
                        ffile = [afiles.(adir{1})(ll).folder,'\',afiles.(adir{1})(ll).name];
                        ifiles.(d{ii})(jj).afile = ffile; % to keep for reference
                        ifiles.(d{ii})(jj).afileref = ll;
                    end
                end
            end
            
            % Calculate the time difference between when the audio file
            % started and when the image was taken, in seconds
            ifiles.(d{ii})(jj).tdiff = ...
                (ifiles.(d{ii})(jj).itime - afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).atime)*24*60*60;
            % Differenc in number of samples
            ifiles.(d{ii})(jj).ndiff = ...
                ifiles.(d{ii})(jj).tdiff*afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate;
            
            % Extract 5 seconds prior to image time, and 5 seconds
            % after image time
            startsamp = ...
                floor(ifiles.(d{ii})(jj).ndiff - 5*afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate);
            if startsamp < 1
                startsamp = 1; % to prevent negative index when there is a gap in the acoustics
            end
            
            endsamp = ...
                ceil(ifiles.(d{ii})(jj).ndiff + 5*afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate);
            
            % Start time for new WAV file so it can be read into Triton
            starttime = ifiles.(d{ii})(jj).itime - 5/(24*60*60); % datenum
            endtime = ifiles.(d{ii})(jj).itime + 5/(24*60*60);
            % Check to see if the ten-second sound clip will would
            % overlap into the next audio file, or for other errors (like
            % no concurrent acoustics during an image)
            
            if endsamp < afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples
                
                [ifiles.(d{ii})(jj).adata,ifiles.(d{ii})(jj).fs] = ...
                    audioread(ifiles.(d{ii})(jj).afile,[startsamp endsamp],'native');
                
                writeflag = 1;
                
            elseif endsamp > afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples && ...
                    ifiles.(d{ii})(jj).afileref+1 < length(afiles.(adir{1})) && ...
                    endtime > afiles.(adir{1})(ifiles.(d{ii})(jj).afileref+1).atime && ...
                    startsamp < afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples % if there is another WAV file
                
                [tempdata1,ifiles.(d{ii})(jj).fs] = ...
                    audioread(ifiles.(d{ii})(jj).afile,...
                    [startsamp afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples],'native');
                
                [tempdata2,ifiles.(d{ii})(jj).fs] = ...
                    audioread([afiles.(adir{1})(ifiles.(d{ii})(jj).afileref+1).folder,'\',afiles.(adir{1})(ifiles.(d{ii})(jj).afileref+1).name],...
                    [1 (endsamp - afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples)],'native');
                
                ifiles.(d{ii})(jj).adata = [tempdata1;tempdata2];
                clear tempdata*
                
                writeflag = 1;
                
            elseif endsamp > afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples && ...
                    ifiles.(d{ii})(jj).afileref+1 > length(afiles.(adir{1})) && ...
                    startsamp < afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples % if there is no other WAV file
                
                [ifiles.(d{ii})(jj).adata,ifiles.(d{ii})(jj).fs] = ...
                    audioread(ifiles.(d{ii})(jj).afile,...
                    [startsamp afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples],'native');
                
                writeflag = 1;
                
            else % if there is some gap in the data or other weird happenstance, write an errorlog to prevent script from breaking
                errorlog.count = errorlog.count + 1;
                errorlog.afiles(errorlog.count) = afiles.(adir{1})(ifiles.(d{ii})(jj).afileref);
                errorlog.ifiles(errorlog.count) = ifiles.(d{ii})(jj);
                
                writeflag = 0;
            end
            
            
            % Write out WAV files for each image file into the image
            % directory
            if writeflag == 1
                
                if afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample == 16
                    audiowrite(...
                        [ifiles.(d{ii})(jj).folder,'\',datestr(starttime,'yymmdd_HHMMSS'),'.wav'],...
                        int16(ifiles.(d{ii})(jj).adata),...
                        afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate,...
                        'BitsPerSample',afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample);
                elseif afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample == 24 || afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample == 32
                    audiowrite(...
                        [ifiles.(d{ii})(jj).folder,'\',datestr(starttime,'yymmdd_HHMMSS'),'.wav'],...
                        int32(ifiles.(d{ii})(jj).adata),...
                        afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate,...
                        'BitsPerSample',afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample);
                else
                    warning('Error: bit size not supported. New WAV file not created')
                    warning(['Nbits = ', num2str(afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample)])
                    return
                end
            elseif writeflag == 0
                % Write a txt file for the photos without audio
                fid = fopen([ifiles.(d{ii})(jj).folder,'\',ifiles.(d{ii})(jj).name(1:end-3),'txt'],'w');
                fprintf(fid,'THIS PHOTO DOES NOT HAVE CONCURRENT ACOUSTIC DATA');
                fclose(fid);
            end
        end
    end
    
elseif mflag == 1
    
    quest = 'Extract all acoustic data, or a subset based on species?';
    ttl = 'Extract Acoustic Data';
    btn1 = 'All acoustics'; btn2 = 'Subset';
    choice = questdlg(quest,ttl,btn1,btn2,btn1);
    
    if strcmp(choice, btn1)
        % Permute each image file time on acoustic file start times to
        % find the WAV that will contain the correct image time.
        for ii = 1:length(fieldnames(ifiles))
            d{ii} = ['d' num2str(ii)];
            for jj = 1:length(ifiles.(d{ii}))
                for kk = 1:length(fieldnames(afiles))
                    adir = {['d',num2str(kk)]};
                    for ll = 1:length(afiles.(adir{1}))
                        if afiles.(adir{1})(ll).atime < ifiles.(d{ii})(jj).itime
                            ffile = [afiles.(adir{1})(ll).folder,'\',afiles.(adir{1})(ll).name];
                            ifiles.(d{ii})(jj).afile = ffile; % to keep for reference
                            ifiles.(d{ii})(jj).afileref = ll;
                        end
                    end
                end
                
                % Calculate the time difference between when the audio file
                % started and when the image was taken, in seconds
                ifiles.(d{ii})(jj).tdiff = ...
                    (ifiles.(d{ii})(jj).itime - afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).atime)*24*60*60;
                % Differenc in number of samples
                ifiles.(d{ii})(jj).ndiff = ...
                    ifiles.(d{ii})(jj).tdiff*afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate;
                
                % Extract 5 seconds prior to image time, and 5 seconds
                % after image time
                startsamp = ...
                    floor(ifiles.(d{ii})(jj).ndiff - 5*afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate);
                if startsamp < 1
                    startsamp = 1; % to prevent negative index when there is a gap in the acoustics
                end
                
                endsamp = ...
                    ceil(ifiles.(d{ii})(jj).ndiff + 5*afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate);
                
                % Start time for new WAV file so it can be read into Triton
                starttime = ifiles.(d{ii})(jj).itime - 5/(24*60*60); % datenum
                endtime = ifiles.(d{ii})(jj).itime + 5/(24*60*60);
                % Check to see if the ten-second sound clip will would
                % overlap into the next audio file, or for other errors (like
                % no concurrent acoustics during an image)
                
                if endsamp < afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples
                    
                    [ifiles.(d{ii})(jj).adata,ifiles.(d{ii})(jj).fs] = ...
                        audioread(ifiles.(d{ii})(jj).afile,[startsamp endsamp],'native');
                    
                    writeflag = 1;
                    
                elseif endsamp > afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples && ...
                        ifiles.(d{ii})(jj).afileref+1 < length(afiles.(adir{1})) && ...
                        endtime > afiles.(adir{1})(ifiles.(d{ii})(jj).afileref+1).atime && ...
                        startsamp < afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples % if there is another WAV file
                    
                    [tempdata1,ifiles.(d{ii})(jj).fs] = ...
                        audioread(ifiles.(d{ii})(jj).afile,...
                        [startsamp afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples],'native');
                    
                    [tempdata2,ifiles.(d{ii})(jj).fs] = ...
                        audioread([afiles.(adir{1})(ifiles.(d{ii})(jj).afileref+1).folder,'\',afiles.(adir{1})(ifiles.(d{ii})(jj).afileref+1).name],...
                        [1 (endsamp - afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples)],'native');
                    
                    ifiles.(d{ii})(jj).adata = [tempdata1;tempdata2];
                    clear tempdata*
                    
                    writeflag = 1;
                    
                elseif endsamp > afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples && ...
                        ifiles.(d{ii})(jj).afileref+1 > length(afiles.(adir{1})) && ...
                        startsamp < afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples % if there is no other WAV file
                    
                    [ifiles.(d{ii})(jj).adata,ifiles.(d{ii})(jj).fs] = ...
                        audioread(ifiles.(d{ii})(jj).afile,...
                        [startsamp afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples],'native');
                    
                    writeflag = 1;
                    
                else % if there is some gap in the data or other weird happenstance, write an errorlog to prevent script from breaking
                    errorlog.count = errorlog.count + 1;
                    errorlog.afiles(errorlog.count) = afiles.(adir{1})(ifiles.(d{ii})(jj).afileref);
                    errorlog.ifiles(errorlog.count) = ifiles.(d{ii})(jj);
                    
                    writeflag = 0;
                end
                
                
                % Write out WAV files for each image file into the image
                % directory
                if writeflag == 1
                    
                    if afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample == 16
                        audiowrite(...
                            [ifiles.(d{ii})(jj).folder,'\',datestr(starttime,'yymmdd_HHMMSS'),'.wav'],...
                            int16(ifiles.(d{ii})(jj).adata),...
                            afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate,...
                            'BitsPerSample',afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample);
                    elseif afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample == 24 || afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample == 32
                        audiowrite(...
                            [ifiles.(d{ii})(jj).folder,'\',datestr(starttime,'yymmdd_HHMMSS'),'.wav'],...
                            int32(ifiles.(d{ii})(jj).adata),...
                            afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate,...
                            'BitsPerSample',afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample);
                    else
                        warning('Error: bit size not supported. New WAV file not created')
                        warning(['Nbits = ', num2str(afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample)])
                        return
                    end
                elseif writeflag == 0
                    % Write a txt file for the photos without audio
                    fid = fopen([ifiles.(d{ii})(jj).folder,'\',ifiles.(d{ii})(jj).name(1:end-3),'txt'],'w');
                    fprintf(fid,'THIS PHOTO DOES NOT HAVE CONCURRENT ACOUSTIC DATA');
                    fclose(fid);
                end
            end
        end
    elseif strcmp(choice,btn2)
        uiwait(msgbox('This feature has not yet been developed. All acoustics will be extracted.'));
        mflag = 2; % Forces the next if statement to run
    end
    
elseif mflag == 2
    
    % Permute each image file time on acoustic file start times to
    % find the WAV that will contain the correct image time.
    for ii = 1:length(fieldnames(ifiles))
        d{ii} = ['d' num2str(ii)];
        for jj = 1:length(ifiles.(d{ii}))
            for kk = 1:length(fieldnames(afiles))
                adir = {['d',num2str(kk)]};
                for ll = 1:length(afiles.(adir{1}))
                    if afiles.(adir{1})(ll).atime < ifiles.(d{ii})(jj).itime
                        ffile = [afiles.(adir{1})(ll).folder,'\',afiles.(adir{1})(ll).name];
                        ifiles.(d{ii})(jj).afile = ffile; % to keep for reference
                        ifiles.(d{ii})(jj).afileref = ll;
                    end
                end
            end
            
            % Calculate the time difference between when the audio file
            % started and when the image was taken, in seconds
            ifiles.(d{ii})(jj).tdiff = ...
                (ifiles.(d{ii})(jj).itime - afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).atime)*24*60*60;
            % Differenc in number of samples
            ifiles.(d{ii})(jj).ndiff = ...
                ifiles.(d{ii})(jj).tdiff*afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate;
            
            % Extract 5 seconds prior to image time, and 5 seconds
            % after image time
            startsamp = ...
                floor(ifiles.(d{ii})(jj).ndiff - 5*afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate);
            if startsamp < 1
                startsamp = 1; % to prevent negative index when there is a gap in the acoustics
            end
            
            endsamp = ...
                ceil(ifiles.(d{ii})(jj).ndiff + 5*afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate);
            
            % Start time for new WAV file so it can be read into Triton
            starttime = ifiles.(d{ii})(jj).itime - 5/(24*60*60); % datenum
            endtime = ifiles.(d{ii})(jj).itime + 5/(24*60*60);
            % Check to see if the ten-second sound clip will would
            % overlap into the next audio file, or for other errors (like
            % no concurrent acoustics during an image)
                        
            if endsamp < afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples
                
                [ifiles.(d{ii})(jj).adata,ifiles.(d{ii})(jj).fs] = ...
                    audioread(ifiles.(d{ii})(jj).afile,[startsamp endsamp],'native');
                
                writeflag = 1;
                
            elseif endsamp > afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples && ...
                    ifiles.(d{ii})(jj).afileref+1 < length(afiles.(adir{1})) && ...
                    endtime > afiles.(adir{1})(ifiles.(d{ii})(jj).afileref+1).atime && ...
                    startsamp < afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples % if there is another WAV file
                
                [tempdata1,ifiles.(d{ii})(jj).fs] = ...
                    audioread(ifiles.(d{ii})(jj).afile,...
                    [startsamp afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples],'native');
                
                [tempdata2,ifiles.(d{ii})(jj).fs] = ...
                    audioread([afiles.(adir{1})(ifiles.(d{ii})(jj).afileref+1).folder,'\',afiles.(adir{1})(ifiles.(d{ii})(jj).afileref+1).name],...
                    [1 (endsamp - afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples)],'native');
                
                ifiles.(d{ii})(jj).adata = [tempdata1;tempdata2];
                clear tempdata*
                
                writeflag = 1;
                
            elseif endsamp > afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples && ...
                    ifiles.(d{ii})(jj).afileref+1 > length(afiles.(adir{1})) && ...
                    startsamp < afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples % if there is no other WAV file
                
                [ifiles.(d{ii})(jj).adata,ifiles.(d{ii})(jj).fs] = ...
                    audioread(ifiles.(d{ii})(jj).afile,...
                    [startsamp afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.TotalSamples],'native');
                
                writeflag = 1;
                
            else % if there is some gap in the data or other weird happenstance, write an errorlog to prevent script from breaking
                errorlog.count = errorlog.count + 1;
                errorlog.afiles(errorlog.count) = afiles.(adir{1})(ifiles.(d{ii})(jj).afileref);
                errorlog.ifiles(errorlog.count) = ifiles.(d{ii})(jj);
                
                writeflag = 0;
            end
            
            
            % Write out WAV files for each image file into the image
            % directory
            if writeflag == 1
                
                if afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample == 16
                    audiowrite(...
                        [ifiles.(d{ii})(jj).folder,'\',datestr(starttime,'yymmdd_HHMMSS'),'.wav'],...
                        int16(ifiles.(d{ii})(jj).adata),...
                        afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate,...
                        'BitsPerSample',afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample);
                elseif afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample == 24 || afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample == 32
                    audiowrite(...
                        [ifiles.(d{ii})(jj).folder,'\',datestr(starttime,'yymmdd_HHMMSS'),'.wav'],...
                        int32(ifiles.(d{ii})(jj).adata),...
                        afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.SampleRate,...
                        'BitsPerSample',afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample);
                else
                    warning('Error: bit size not supported. New WAV file not created')
                    warning(['Nbits = ', num2str(afiles.(adir{1})(ifiles.(d{ii})(jj).afileref).info.BitsPerSample)])
                    return
                end
            elseif writeflag == 0
                % Write a txt file for the photos without audio
                fid = fopen([ifiles.(d{ii})(jj).folder,'\',ifiles.(d{ii})(jj).name(1:end-3),'txt'],'w');
                fprintf(fid,'THIS PHOTO DOES NOT HAVE CONCURRENT ACOUSTIC DATA');
                fclose(fid);
            end
        end
    end
end

% clean up the errorlog to pull out unique acoustic filenames
if isfield(errorlog,'afiles')
    for ii = 1:length(errorlog.afiles)
        names{ii} = errorlog.afiles(ii).name;
    end
end

errorlog.uniqueAcousticFiles = unique(names);

toc(t1)
uiwait(msgbox(['Script finished acoustic data extraction at: ',datestr(now)]));

%% Optional photo/acoustic viewer
% All the extracted acoustic data is within the ifiles structure, so no
% need to audioread the just-created WAVs.
% Most of this section was shamelessly stolen from C Pagniello's
% image_processing scripts and modified
quest = 'View photos and associated audio?'; ttl = 'View Images/Audio';
btn1 = 'Yes'; btn2 = 'No';
choice = questdlg(quest,ttl,btn1,btn2,btn1);

if strcmp(choice,btn1)

  view_image_and_acoustics
    
else
    uiwait(msgbox('User elected not to view images/acoustics. Script terminates.'));
    return
end
        
                        
                        













