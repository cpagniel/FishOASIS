%% Get Point

MAIN.cnt = MAIN.cnt+1;

cp1 = get(MAIN.ha1,'currentpoint');
cpck = cp1(1,1:2);

DATA.XX(MAIN.cnt) = cp1(1,1);
DATA.YY(MAIN.cnt) = cp1(1,2);
DATA.XXYY_SCODE(MAIN.cnt) = PARAMS.icur;

%% Plot Point

hold on

plot(DATA.XX(MAIN.cnt),DATA.YY(MAIN.cnt),'ko','MarkerFaceColor',PARAMS.scol(PARAMS.icur,:),'MarkerSize',8);
text(DATA.XX(MAIN.cnt)+20,DATA.YY(MAIN.cnt)-20,num2str(PARAMS.icur),'FontSize',MAIN.snsize,'Color',PARAMS.scol(PARAMS.icur,:),'FontWeight','bold');

%% Update Count

DATA.COUNT(PARAMS.icur) = DATA.COUNT(PARAMS.icur)+1;

x0 = 0.50; y0 = 1.00;
if PARAMS.icur >= PARAMS.icntmax
    x0 = x0 + 0.10;
    y0 = y0 - 0.02*(PARAMS.icur-PARAMS.icntmax+1);
else
    y0 = y0 - 0.02*(PARAMS.icur);
end

if PARAMS.icur < 20
    MAIN.hu3(PARAMS.icur) = uicontrol(MAIN.hf1,'un','n','style','tex','pos',[x0+0.06 y0 .03 .02], ...
            'str',num2str(DATA.COUNT(PARAMS.icur)),'tag','hu','fontsize',9,'fontweight','b',...
            'backgroundcolor',PARAMS.scol(PARAMS.icur,:),'foregroundcolor','w');
else
MAIN.hu3(PARAMS.icur) = uicontrol(MAIN.hf1,'un','n','style','tex','pos',[x0+0.06 y0 .03 .02], ...
    'str',num2str(DATA.COUNT(PARAMS.icur)),'tag','hu','fontsize',9,'fontweight','b',...
    'backgroundcolor',PARAMS.scol(PARAMS.icur,:));
end

clear cp1 cpck x0 y0 
