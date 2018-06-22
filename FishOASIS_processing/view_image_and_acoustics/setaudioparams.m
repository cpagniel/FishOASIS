%% Set Parameters

DATA.DATE=get(PARAMS.hadate,'str');
DATA.TIME=get(PARAMS.hatime,'str');

PARAMS.fft = str2double(get(PARAMS.hfft,'str'));
PARAMS.ovlap = str2double(get(PARAMS.hovlap,'str'));
PARAMS.lfreq = str2double(get(PARAMS.hlfreq,'str'));
PARAMS.ufreq = str2double(get(PARAMS.hufreq,'str'));
PARAMS.ch = str2double(get(PARAMS.hch,'str'));

if ~isnumeric(PARAMS.clower) || ...
        ~isnumeric(PARAMS.cupper) || ...
        isnan(str2double(get(PARAMS.hclower,'str'))) || ...
        isnan(str2double(get(PARAMS.hcupper,'str'))) % in case user enters something besides a number
    
    uiwait(msgbox('Check dB parameters and try again'));
    
else
    
    PARAMS.clower = str2double(get(PARAMS.hclower,'str'));
    PARAMS.cupper = str2double(get(PARAMS.hcupper,'str'));
    
end



set(MAIN.control.hinitlogger,'en','on');

draw_specgram