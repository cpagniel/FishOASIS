%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Draw spectrogram
%
% Called by view_image_and_acoustics, this draws the spectrogram into the
% acoustics window using the user defined parameters.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check drawflag
if PARAMS.drawflag == 1
    
    %% Calculate Spectrogram
    if ~ischar(PARAMS.ch)
        
        [DATA.AUDIO.SPECTRO.S, DATA.AUDIO.SPECTRO.F,...
            DATA.AUDIO.SPECTRO.T, DATA.AUDIO.SPECTRO.P] = ...
            spectrogram(double(DATA.AUDIO.data(:,PARAMS.ch)),blackman(PARAMS.fft),...
            floor((PARAMS.ovlap/100)*PARAMS.fft),PARAMS.fft,DATA.AUDIO.info.SampleRate);
        
    else
        
        [DATA.AUDIO.SPECTRO.S, DATA.AUDIO.SPECTRO.F,...
            DATA.AUDIO.SPECTRO.T, DATA.AUDIO.SPECTRO.P] = ...
            spectrogram(double(DATA.AUDIO.data(:,str2double(PARAMS.ch))),...
            blackman(str2double(PARAMS.fft)),...
            floor((str2double(PARAMS.ovlap)/100)*str2double(PARAMS.fft)),...
            str2double(PARAMS.fft),DATA.AUDIO.info.SampleRate);
    end
    
    %% Draw Spectrogram
    figure(MAIN.hf2);
    MAIN.ha2 = gca;
    
    % Create absolute time variable to make logging easier
    DATA.AUDIO.Tstart = datenum(PARAMS.aname(1:end-4),'yymmdd_HHMMSS');
    DATA.AUDIO.Tend = DATA.AUDIO.Tstart + DATA.AUDIO.info.Duration/(24*60*60);
    DATA.AUDIO.Tabs = linspace(DATA.AUDIO.Tstart,DATA.AUDIO.Tend,length(DATA.AUDIO.SPECTRO.T));
    
    % Draw the image
    MAIN.hspec = imagesc(MAIN.ha2,...
        DATA.AUDIO.Tabs,DATA.AUDIO.SPECTRO.F,10*log10(DATA.AUDIO.SPECTRO.P));
    set(MAIN.ha2,'ydir','normal','position',[0.08 0.115 0.7 0.8]);
    MAIN.aplot.xtic = linspace(DATA.AUDIO.Tstart,DATA.AUDIO.Tend,11); xticks(MAIN.aplot.xtic);
    MAIN.aplot.xlab = {'','1','2','3','4','5','6','7','8','9',''}; xticklabels(MAIN.aplot.xlab);
    ylim([50 DATA.AUDIO.info.SampleRate/2]);
    ylabel('Frequency (Hz)'); xlabel('Time (s)');
    colormap(jet);
    
    %% Adjust Parameters based on user input
    
    % Adjust color scaling
    if ~ischar(PARAMS.clower) && ~ischar(PARAMS.cupper)
        caxis([PARAMS.clower PARAMS.cupper])
    else
        MAIN.cax = caxis;
        PARAMS.clower = MAIN.cax(1);
        PARAMS.cupper = MAIN.cax(2);
    end
    
    % Adjust frequency axis
    if ~ischar(PARAMS.lfreq) && ~ischar(PARAMS.ufreq)
        
        if PARAMS.lfreq >= 0 && PARAMS.ufreq <= DATA.AUDIO.info.SampleRate/2
            
            ylim([PARAMS.lfreq PARAMS.ufreq]);
            
        elseif PARAMS.lfreq < 0 && PARAMS.ufreq <= DATA.AUDIO.info.SampleRate/2
            
            uiwait(msgbox('Frequency set below 0 Hz. Setting lower frequency to 0'));
            ylim([0 PARAMS.ufreq]);
            PARAMS.lfreq = 0;
            set(PARAMS.hlfreq,'str',num2str(PARAMS.lfreq));
            
        elseif PARAMS.lfreq >= 0 && PARAMS.ufreq > DATA.AUDIO.info.SampleRate/2
            
            uiwait(msgbox('Upper frequency set above Nyquist. Setting upper frequency to Fs/2'));
            ylim([PARAMS.lfreq DATA.AUDIO.info.SampleRate/2]);
            PARAMS.ufreq = DATA.AUDIO.info.SampleRate/2;
            set(PARAMS.hufreq,'str',num2str(PARAMS.ufreq));
            
        else
            
            uiwait(msgbox('Check frequency bounds and try again'));
            
        end
    end
    
    %% Don't draw a new spectrogram since there is no audio data
elseif PARAMS.drawflag == 0
    
    figure(MAIN.hf2);
    MAIN.ha2 = gca;
    cla(MAIN.ha2);
    
    set(MAIN.ha2,'xtick',[],'xticklabel','','xcolor',[1 1 1],...
        'ytick',[],'yticklabel','','ycolor',[1 1 1],...
        'box','off');
    
    PARAMS.adate='enter date';
    PARAMS.atime='enter time';
    PARAMS.fft = '256';
    PARAMS.ovlap = '90';
    PARAMS.lfreq = '50';
    PARAMS.ufreq = '1000';
    PARAMS.ch = '1';
    PARAMS.clower = 'N/A';
    PARAMS.cupper = 'N/A';
    
    init_audio_params
end

