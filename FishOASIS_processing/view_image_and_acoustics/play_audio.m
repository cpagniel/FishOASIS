%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Play Audio
%
% Called by view_image_and_acoustics, this script plays the audio data
% plotted within the spectrogram window.
%
% Modified from Triton's audvidplayer script
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get volume multiplier and adjust data
PARAMS.vol = str2double(get(PARAMS.hvol,'str'));
PARAMS.ch = str2double(get(PARAMS.hch,'str'));
DATA.AUDIO.pdata = DATA.AUDIO.data(:,PARAMS.ch)*PARAMS.vol;
% Start Audio Player
BIN.aplay = audioplayer(DATA.AUDIO.pdata,DATA.AUDIO.info.SampleRate);

% Set-up indicator line

BIN.y = [min(get(MAIN.hspec,'ydata')),max(get(MAIN.hspec,'ydata'))];
BIN.x = [min(DATA.AUDIO.Tabs),min(DATA.AUDIO.Tabs)];


% line for animation
h = line(MAIN.ha2,x,y,'Color','k','LineWidth',4);

% start audio playing the data segment
play(BIN.aplay)

% do animation and keep player running until done
while isplaying(BIN.aplay)
    BIN.x = ...
        [min(DATA.AUDIO.Tabs),min(DATA.AUDIO.Tabs)]+ ...
        ((length(DATA.AUDIO.pdata)/DATA.AUDIO.info.SampleRate)*get(BIN.aplay,'CurrentSample')/length(DATA.AUDIO.pdata)/(24*60*60));
    set(h,'Xdata',BIN.x,'Ydata',BIN.y)
    drawnow
end

delete(h);