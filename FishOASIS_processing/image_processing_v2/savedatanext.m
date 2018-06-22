%% Save data in .mat

DATA.COMMENTS=get(PARAMS.hicomments,'str'); % save comments

DATA.SCODE = PARAMS.scode; % save species codes
DATA.SCOL = PARAMS.scol; % save species colors
DATA.SNUMB = PARAMS.snumb; % save species number
DATA.SFULL = PARAMS.sfull; % save full species name

cd(PARAMS.idir);
save([DATA.FILENAME(1:end-4) '.mat']);

%% Clear

clear
clc
close all

%% Reload program and get next image

image_processing_v2