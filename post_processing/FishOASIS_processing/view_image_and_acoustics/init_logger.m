%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Initialize Logger
%
% This script allows the user to log fish calls from the acoustics
% associated with FishOASIS images. Unlike the Logger remora in Triton,
% this scripts works similar to image_processing_v2, in that the user
% selects from a checkbox list of possible calls, then click on the
% spectrogram image, and save all the calls into a MAT file.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global MAIN
%% Create Logger Button
MAIN.control.hinitlogger=uicontrol(MAIN.hf2,'style','togglebutton','un','n',...
    'pos',[.800 .860 .200 .05],...
    'str','Log Calls','call','log_calls','Value',PARAMS.logger.val);

if MAIN.control.hinitlogger.Value == 0
    set(MAIN.control.hinitlogger,'BackgroundColor',[.94 .94 .94]);
elseif MAIN.control.hinitlogger.Value == 1
        set(MAIN.control.hinitlogger,'BackgroundColor',[.2 .8 .2]);
end

MAIN.control.hdel = uicontrol(MAIN.hf2,'style','push','un','n',...
    'pos',[.9 .92 .1 .08],'str','Delete Logged Calls',...
    'call','delete_logged_calls');

% Turn off logger button until Audio Parameters have been set
if ischar(PARAMS.fft)
    set(MAIN.control.hinitlogger,'en','off');
end