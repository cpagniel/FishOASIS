%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Initialize Audio Parameters
%
% Called by view_image_and_acoustics, this script initializes the
% parameters within the spectrogram window
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MAIN.control.hsetparams=uicontrol(MAIN.hf2,'style','push','un','n','pos',[.800 .806 .200 .05],...
    'str','Set Audio Parameters','call','setaudioparams');

MAIN.control.hadate=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.800 .730 .06 .06], ...
    'str','Date','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hadate=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.870 .730 .06 .06], ...
    'str',PARAMS.adate,'foreg',[0 0 1],'backg',[1 1 1]);

MAIN.control.hatime=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.800 .670 .06 .06], ...
    'str','Time','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hatime=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.870 .670 .06 .06], ...
    'str',PARAMS.atime,'foreg',[0 0 1],'backg',[1 1 1]);

MAIN.control.hfft=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.800 .600 .06 .06], ...
    'str','FFT','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hfft=uicontrol(MAIN.hf2,'style','edit','un','n','pos',[.870 .600 .06 .06], ...
    'str',PARAMS.fft,'foreg',[0 0 1],'backg',[1 1 1]);

MAIN.control.hovlap=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.800 .530 .06 .06], ...
    'str','Overlap','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hovlap=uicontrol(MAIN.hf2,'style','edit','un','n','pos',[.870 .530 .06 .06], ...
    'str',PARAMS.ovlap,'foreg',[0 0 1],'backg',[1 1 1]);

MAIN.control.hlfreq=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.800 .470 .06 .06], ...
    'str','L Freq','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hlfreq=uicontrol(MAIN.hf2,'style','edit','un','n','pos',[.870 .470 .06 .06], ...
    'str',PARAMS.lfreq,'foreg',[0 0 1],'backg',[1 1 1]);

MAIN.control.hufreq=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.800 .400 .06 .06], ...
    'str','U Freq','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hufreq=uicontrol(MAIN.hf2,'style','edit','un','n','pos',[.870 .400 .06 .06], ...
    'str',PARAMS.ufreq,'foreg',[0 0 1],'backg',[1 1 1]);

MAIN.control.hch=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.800 .330 .06 .06], ...
    'str','Channel','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hch=uicontrol(MAIN.hf2,'style','edit','un','n','pos',[.870 .330 .06 .06], ...
    'str',PARAMS.ch,'foreg',[0 0 1],'backg',[1 1 1]);

MAIN.control.hclower=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.800 .270 .06 .06], ...
    'str','dB Lower','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hclower=uicontrol(MAIN.hf2,'style','edit','un','n','pos',[.870 .270 .06 .06], ...
    'str',PARAMS.clower,'foreg',[0 0 1],'backg',[1 1 1]);

MAIN.control.hcupper=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.800 .200 .06 .06], ...
    'str','dB Upper','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hcupper=uicontrol(MAIN.hf2,'style','edit','un','n','pos',[.870 .200 .06 .06], ...
    'str',PARAMS.cupper,'foreg',[0 0 1],'backg',[1 1 1]);

MAIN.control.hplay=uicontrol(MAIN.hf2,'style','push','un','n','pos',[.800 .130 .200 .05],...
    'str','Play Audio','call','play_audio');
MAIN.control.hvol=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.800 .06 .06 .06], ...
    'str','Volume','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hvol=uicontrol(MAIN.hf2,'style','edit','un','n','pos',[.870 .06 .06 .06], ...
    'str',PARAMS.vol,'foreg',[0 0 1],'backg',[1 1 1]);