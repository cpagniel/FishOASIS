%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Initialize Controls
%
% Called by view_image_and_acoustics, this script creates the buttons to
% control the analysis environment.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MAIN.control.hmen3 = uimenu(MAIN.hf1,'lab','Open Image','call','openimage');

MAIN.control.hmen3a=uimenu(MAIN.hf1,'lab','Previous Image','sep','on','call','previous_image');

MAIN.control.hmen3b=uimenu(MAIN.hf1,'lab','Next Image','call','next_image');

MAIN.control.hmen3c=uimenu(MAIN.hf1,'lab','Quit','call',...
    ['if isfield(MAIN,''hf1''),delete(MAIN.hf1),end;'...
    'if isfield(MAIN,''hf2''),delete(MAIN.hf2),end;'...
    'if isfield(MAIN,''hf3''),delete(MAIN.hf3),end;'...
    'clear(''all'',''global'')']);