%% Set Current Species Code

ix = gco;
PARAMS.icur = str2double(ix.String(1:2));

set(MAIN.hstatus10,'str',char(PARAMS.sfull(PARAMS.icur,:)));
set(MAIN.hstatus10,'backg',PARAMS.scol(PARAMS.icur,:));

%% Get Click Point

set(MAIN.hf1,MAIN.wbd,'getpt');

clear ix