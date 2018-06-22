%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Draw Image
%
% Called from view_image_and_acoustics, this script draws the image into
% the exists image window
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Draw Image
figure(MAIN.hf1);
clf(MAIN.ha1); % clear the image from the figure window to prevent the program using too much memory

% Redraw controls
init_controls
    
MAIN.hi1 = image(DATA.IMG,'Parent',MAIN.ha1);
axis('off');

if ~isfield(MAIN,'httl') || ~isvalid(MAIN.httl)
    MAIN.httl = title(datestr(datenum(PARAMS.ifile(1:end-4),'yymmdd_HHMMSS'),0));
else
    set(MAIN.httl,'String','');
    MAIN.httl = title(datestr(datenum(PARAMS.ifile(1:end-4),'yymmdd_HHMMSS'),0));
end