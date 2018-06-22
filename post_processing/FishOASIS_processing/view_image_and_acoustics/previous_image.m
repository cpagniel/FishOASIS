%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Previous Image
% 
% Called from view_image_and_acoustics to go back one image before the
% curently displayed image.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clear Variables
clearvars -except PARAMS MAIN
PARAMS.log.count = []; PARAMS.log.current = [];
%% Get the index for the current image
for ii=1:length(PARAMS.files) % ii will be the index
        if strcmp(PARAMS.ifile,PARAMS.files(ii).name)
            break
        end
end
    
if ii > 1
    % Set the path ahead one
    PARAMS.ifile = PARAMS.files(ii-1).name;
    PARAMS.idir = [PARAMS.files(ii-1).folder,'\'];
    PARAMS.ipath = [PARAMS.idir PARAMS.ifile];
    
    set(MAIN.httl,'str','');
    
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
    if isfield(MAIN,'hf3')
        if isvalid(MAIN.hf3)
            display_call_parameters
        end
    end
        
    view_image_and_acoustics
    
elseif ii == 1
    
    % You've reached the end of the directory
    uiwait(msgbox('This is the first image in the directory.'));
    return
    
else % if there is something wierd happening - shouldn't ever display this
    
    uiwait(msgbox('Something is amiss. Try loading a different image.'));
    return
    
end

