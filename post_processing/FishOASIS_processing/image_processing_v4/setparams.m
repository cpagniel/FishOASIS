%% Set Parameters

DATA.DATE=get(PARAMS.hidate,'str');
DATA.TIME=get(PARAMS.hitime,'str');
DATA.FILENAME=get(PARAMS.hiname,'str');
DATA.QUALITY=get(PARAMS.hiqual,'str');

set(PARAMS.hidate,'en','off')
set(PARAMS.hitime,'en','off')
set(PARAMS.hiname,'en','off')
set(PARAMS.hiqual,'en','off')

set(MAIN.hf1,MAIN.wbd,'',MAIN.wbm,'',MAIN.wbu,'');
set(MAIN.hu1,'en','on')