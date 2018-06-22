global MAIN
%% Get which radio is active
for ii = 1:length(fieldnames(MAIN.log.call))
    h = {['h',num2str(ii)]};
    if MAIN.log.call.(h{1}).Value == 1
        MAIN.log.cnt = 0;
        break
    end
end

%% Get the call info
if MAIN.log.call.(h{1}).UserData == 0
    uiwait(msgbox('No call info extracted from spectrogram'));
    return
end

MAIN.done = uicontrol(MAIN.log.bg,'style','push','un','n',...
    'pos',MAIN.log.call.(h{1}).Position,'str','Done','foreg',[0 0 0],'backg',[.94 .94 .94],...
    'call',...
    ['set(MAIN.log.call.(h{1}),''Value'',0);'...
    'set(MAIN.hf2,''WindowButtonDownFcn'','''',''WindowButtonUpFcn'','''');'
    'delete(gcbo);hold(MAIN.ha2)']);

set(MAIN.hf2,'WindowButtonDownFcn','get_start_point');
set(MAIN.hf2,'WindowButtonUpFcn','get_end_point');

hold(MAIN.ha2);
LOG.filename = DATA.AUDIO.info.Filename(1:end-4);
LOG.(h{1}).type = MAIN.log.call.(h{1}).String;

