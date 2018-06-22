%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Save Species Selection
%
% This script saves a .MAT file that includes the selected species' names,
% the times at which they were seen, and the associated image file name to
% make it easy to load into view_image_and_acoustics.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get the indexes for times when specific species were counted
if exist('spcounts','var')
    
    sp = find(spcounts ~= 0); tsp = time(sp);
    
elseif exist('checked','var')
    
    spcounts = [];
    if length(checked) == 1
        for ii = 1:length(fieldnames(iDATA))
            spcounts = [spcounts; iDATA.(d{ii}).count(:,checked)];
        end
    else
        for ii = 1:length(fieldnames(iDATA))
            spcounts = [spcounts,sum(iDATA.(d{ii}).count(:,checked)')];
        end
    end
    
    sp = find(spcounts ~= 0); tsp = time(sp);
    
else
    uiwait(msgbox('Select species before saving'));
    return
end

%% Create and save structure
spDATA.species = iDATA.day1.species(checked)';
spDATA.times = datestr(tsp);
spDATA.dnums = tsp;

for ii = 1:length(tsp)
    spDATA.ifiles{ii,1} = [datestr(tsp(ii),'yymmdd_HHMMSS'),'.jpg'];
end

[fname pname] = uiputfile('*.mat','Save Selected Species');

if fname ~= 0
    save([pname fname],'spDATA','-v7.3');
else
    uiwait(msgbox('User canceled file save'));
    return
end

