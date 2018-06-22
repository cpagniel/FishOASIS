%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get Audio Date and Time
%
% Called by view_image_and_acoustics, this script grabs the date and time
% of the audio files from their names
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PARAMS.hadate=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.870 .730 .06 .06], ...
    'str',datestr(datenum(PARAMS.aname(1:6),'yymmdd'),'mm/dd/yy'),'foreg',[0 0 1],'backg',[1 1 1]);

PARAMS.hatime=uicontrol(MAIN.hf2,'style','text','un','n','pos',[.870 .670 .06 .06], ...
    'str',[num2str(PARAMS.aname(8:9)) ':' num2str(PARAMS.aname(10:11)) ':' num2str(PARAMS.aname(12:13))],...
    'foreg',[0 0 1],'backg',[1 1 1]);