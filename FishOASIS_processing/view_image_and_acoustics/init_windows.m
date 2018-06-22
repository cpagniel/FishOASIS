%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Initialize Image and Acoustic Windows
%
% Called by view_image_and_acoustics, this script initializes the windows
% in which the images and spectrograms will be drawn.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global MAIN

MAIN.verno=' View Image and Acoustics v.1';
MAIN.figwidth = 0.35;
MAIN.figheight = 0.85;
MAIN.afigwidth = .6;
MAIN.afigheight = .4;
MAIN.lfigwidth = .3;
MAIN.lfigheight = .3;

MAIN.wbd='WindowButtonDown';
MAIN.wbm='WindowButtonMotion';
MAIN.wbu='WindowButtonUp';

MAIN.snsize = 12;
MAIN.visval = 'off';

MAIN.cnt = 0;

MAIN.hf1 = figure(1);
MAIN.hf2 = figure(2);

set(MAIN.hf1,'numb','off');
set(MAIN.hf1,'name','Processed Image');
set(MAIN.hf1,'units','norm','pos',[0.02 0.08 MAIN.figwidth MAIN.figheight],'menubar','none');
set(MAIN.hf1,'CloseRequestFcn',...
    'close(''all'',''force'');;clear(''all'',''global'')');

set(MAIN.hf2,'numb','off');
set(MAIN.hf2,'name','Concurrent Acoustics');
set(MAIN.hf2,'units','norm','pos',[0.3812 0.175 MAIN.afigwidth MAIN.afigheight],'menubar','none');

if ~exist('PARAMS','var')
    PARAMS.drawflag = 1;
    PARAMS.spflag = 2;
    PARAMS.adate='enter date';
    PARAMS.atime='enter time';
    PARAMS.fft = '256';
    PARAMS.ovlap = '90';
    PARAMS.lfreq = '50';
    PARAMS.ufreq = '1000';
    PARAMS.ch = '1';
    PARAMS.clower = 'N/A';
    PARAMS.cupper = 'N/A';
    PARAMS.vol = '5';
    PARAMS.logger.val = 0;
end

% Creat axes container for image
MAIN.ha1 = axes(MAIN.hf1,'position',[.1 .06 .8 .9],...
    'xtick',[],'xticklabel','','xcolor',[1 1 1],...
    'ytick',[],'yticklabel','','ycolor',[1 1 1],...
    'box','off');
axis('off');

% Create axes container for spectrogram
figure(MAIN.hf2);
MAIN.ha2 = gca;
