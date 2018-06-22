%% Save data in .mat

DATA.COMMENTS=get(PARAMS.hicomments,'str'); % save comments

DATA.SCODE = PARAMS.scode; % save species codes
DATA.SCOL = PARAMS.scol; % save species colors
DATA.SNUMB = PARAMS.snumb; % save species number
DATA.SFULL = PARAMS.sfull; % save full species name

cd(PARAMS.idir);
save([DATA.FILENAME(1:end-4) '.mat']);

%% Clear

clearvars -except PARAMS
clc
close all

%% Reload program and automatically load next image

% Find the index of the current file
comp = zeros(size(PARAMS.files));
for i = 1:length(PARAMS.files)
   comp(i) = strcmp(PARAMS.ifile,PARAMS.files(i).name);
end
idx = find(comp == 1);

% Check to see if it's the last image
if idx+1 > length(PARAMS.files)
    
    close all
    uiwait(msgbox('All files within the directory have been processed',...
        'ALL DONE!'));
    
else
    
    % Set PARAMS.ifile to the next filename and rerun program
    PARAMS.ifile = PARAMS.files(idx+1).name;
    image_processing_v2
    
end
