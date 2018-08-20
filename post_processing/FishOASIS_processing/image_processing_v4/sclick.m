%% Set Current Species Code

ix = gco;
if isnan(str2double(ix.String(3)))
    PARAMS.icur = str2double(ix.String(1:2));
else
    PARAMS.icur = str2double(ix.String(1:3));
end

set(MAIN.hstatus10,'str',char(PARAMS.sfull(PARAMS.icur,:)));
set(MAIN.hstatus10,'backg',PARAMS.scol(PARAMS.icur,:));

%% Get Click Point

set(MAIN.hf1,MAIN.wbd,'getpt2');

clear ix