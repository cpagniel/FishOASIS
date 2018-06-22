%% Get Point

cp2 = get(MAIN.ha2,'currentpoint');
cpckend = cp2(1,1:2);

%% Log the call parameters and plot
% Update call count
LOG.(h{1}).count = MAIN.log.cnt; PARAMS.log.count.(h{1}) = MAIN.log.cnt;

% Log call start and end time
if cpckstart(1,1) < cpckend(1,1)
    LOG.(h{1}).info(MAIN.log.cnt).start = cpckstart(1,1);
    LOG.(h{1}).info(MAIN.log.cnt).end = cpckend(1,1);
    PARAMS.log.current.start = datestr(cpckstart(1,1),'HH:MM:SS.FFF');
    PARAMS.log.current.end = datestr(cpckend(1,1),'HH:MM:SS.FFF');
else
    LOG.(h{1}).info(MAIN.log.cnt).start = cpckend(1,1);
    LOG.(h{1}).info(MAIN.log.cnt).end = cpckstart(1,1);
    PARAMS.log.current.start = datestr(cpckend(1,1),'HH:MM:SS.FFF');
    PARAMS.log.current.end = datestr(cpckstart(1,1),'HH:MM:SS.FFF');
end

% Log call upper and lower frequencies
if cpckstart(1,2) < cpckend(1,2)
    LOG.(h{1}).info(MAIN.log.cnt).LFreq = cpckstart(1,2);
    LOG.(h{1}).info(MAIN.log.cnt).UFreq = cpckend(1,2);
    PARAMS.log.current.upper = num2str(floor(cpckend(1,2)));
    PARAMS.log.current.lower = num2str(floor(cpckstart(1,2)));
else
    LOG.(h{1}).info(MAIN.log.cnt).LFreq = cpckend(1,2);
    LOG.(h{1}).info(MAIN.log.cnt).UFreq = cpckstart(1,2);
    PARAMS.log.current.upper = num2str(floor(cpckstart(1,2)));
    PARAMS.log.current.lower = num2str(floor(cpckend(1,2)));
end

% Plot the rectangle to keep track of what's been logged
MAIN.rectplot.(h{1}).r(MAIN.log.cnt) = rectangle(MAIN.ha2,...
    'pos',[LOG.(h{1}).info(MAIN.log.cnt).start,...
    LOG.(h{1}).info(MAIN.log.cnt).LFreq,...
    LOG.(h{1}).info(MAIN.log.cnt).end-LOG.(h{1}).info(MAIN.log.cnt).start,...
    LOG.(h{1}).info(MAIN.log.cnt).UFreq-LOG.(h{1}).info(MAIN.log.cnt).LFreq],...
    'edgecolor',MAIN.log.call.(h{1}).BackgroundColor,'linewidth',2);

LOG.(h{1}).plot = MAIN.rectplot.(h{1}).r;

display_call_parameters