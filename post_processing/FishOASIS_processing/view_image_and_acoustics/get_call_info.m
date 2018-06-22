%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get Call Info
%
% Pulls the data from the mouse click and drag into a structure to log the
% calls
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
if MAIN.log.call.(h{1}).UserData == 1
    callinfo = [];
elseif MAIN.log.call.(h{1}).UserData == 0
    uiwait(msgbox('No call info extracted from spectrogram'));
    return
end

if exist('callinfo','var')
    hold(MAIN.ha2);
    LOG.filename = DATA.AUDIO.info.Filename(1:end-4);
    LOG.(h{1}).type = MAIN.log.call.(h{1}).String;
    
    MAIN.done = uicontrol(MAIN.log.bg,'style','push','un','n',...
        'pos',MAIN.log.call.(h{1}).Position,'str','Done','foreg',[0 0 0],'backg',[.94 .94 .94],...
        'call','delete(gcbo);set(MAIN.log.call.(h{1}),''Value'',0)');
%     while ishandle(MAIN.done)
        callinfo = getrect(MAIN.ha2);
        MAIN.log.cnt = MAIN.log.cnt+1;
        LOG.(h{1}).count = MAIN.log.cnt;
        LOG.(h{1}).info(MAIN.log.cnt).start = callinfo(1);
        LOG.(h{1}).info(MAIN.log.cnt).end = callinfo(1)+callinfo(3);
        LOG.(h{1}).info(MAIN.log.cnt).LFreq = callinfo(2);
        LOG.(h{1}).info(MAIN.log.cnt).UFreq = callinfo(4);
        
        % Plot the rectangle to keep track of what's been logged
        MAIN.r(MAIN.log.cnt) = rectangle(MAIN.ha2,'pos',callinfo,...
            'edgecolor',MAIN.log.call.(h{1}).BackgroundColor,'linewidth',2);
        
        pause(.01);
%     end
    hold(MAIN.ha2);
    clear callinfo;
    datacursormode('off');
    return
end














