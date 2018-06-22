%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Delete Logged Calls
%
% Removes all logged calls from an image/acoustic pair
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Delete rectangle objects from spectrogram axis
if isfield(MAIN,'rectplot')
    
    for ii = 1:length(fieldnames(MAIN.rectplot))
        h{ii} = ['h',num2str(ii)];
        delete(MAIN.rectplot.(h{ii}).r);
    end
           
    % Clear LOG structure
    clear LOG
    
    % Reset call counts
    PARAMS.log.count.h1 = 0;
    PARAMS.log.count.h2 = 0;
    PARAMS.log.count.h3 = 0;
    PARAMS.log.count.h4 = 0;
    PARAMS.log.count.h5 = 0;
    
    % Reset last call parameters
    PARAMS.log.current.start = 'N/A';
    PARAMS.log.current.end = 'N/A';
    PARAMS.log.current.upper = 'N/A';
    PARAMS.log.current.lower = 'N/A';
    
    % Update call counts display
    if isvalid(MAIN.hf3)
        display_call_parameters
    end
    
else
    
    uiwait(msgbox('No calls have been logged'));
    
end
