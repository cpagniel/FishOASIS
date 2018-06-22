%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Load Logged Calls
%
% Loads previously logged calls and displays them on the spectrogram
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BIN.snamefull = [DATA.AUDIO.info.Filename(1:end-4),'_CallLog','.mat'];
BIN.sinfo = dir(BIN.snamefull);

if ~isempty(BIN.sinfo)
    clear LOG
    load(BIN.snamefull);
else
    uiwait(msgbox('No logged calls exist for this audio file'));
    return,
end

% No previously selected call, so go back to defaults
PARAMS.log.current.start = 'N/A';
PARAMS.log.current.end = 'N/A';
PARAMS.log.current.upper = 'N/A';
PARAMS.log.current.lower = 'N/A';

% Find out which calls were logged,set their counts, and plot them
hold(MAIN.ha2);
for ii = 1:5
    h{ii} = ['h',num2str(ii)];
    
    if isfield(LOG,h{ii})
        PARAMS.log.count.(h{ii}) = LOG.(h{ii}).count;
        
        for jj = 1:length(LOG.(h{ii}).plot)
            MAIN.rectplot.(h{ii}).r(jj) = rectangle(MAIN.ha2,...
                'position',LOG.(h{ii}).plot(jj).Position,...
                'EdgeColor',LOG.(h{ii}).plot(jj).EdgeColor,...
                'LineWidth',LOG.(h{ii}).plot(jj).LineWidth);
        end
    end
    
end
hold(MAIN.ha2);

% Update call parameters
display_call_parameters

       
       