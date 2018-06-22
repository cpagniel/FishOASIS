%% Get Point

MAIN.cnt = MAIN.cnt+1;

cp1 = get(MAIN.ha1,'currentpoint');
cp2 = ginput(2);

DATA.XXc(MAIN.cnt) = cp1(1,1);
DATA.YYc(MAIN.cnt) = cp1(1,2);

DATA.XX1(MAIN.cnt) = cp2(1,1);
DATA.YY1(MAIN.cnt) = cp2(1,2);

DATA.XX2(MAIN.cnt) = cp2(2,1);
DATA.YY2(MAIN.cnt) = cp2(2,2);

DATA.rect_SCODE(MAIN.cnt) = PARAMS.icur;

%% Calculate Rectangle Width and Height

DATA.rect_WIDTH(MAIN.cnt) = DATA.XX2(MAIN.cnt)-DATA.XX1(MAIN.cnt);
DATA.rect_HEIGHT(MAIN.cnt) = DATA.YY2(MAIN.cnt)-DATA.YY1(MAIN.cnt);

%% Plot Point

hold on

plot(DATA.XXc(MAIN.cnt),DATA.YYc(MAIN.cnt),'ko','MarkerFaceColor',PARAMS.scol(PARAMS.icur,:),'MarkerSize',8);
text(DATA.XXc(MAIN.cnt)+20,DATA.YYc(MAIN.cnt)-20,num2str(PARAMS.icur),'FontSize',MAIN.snsize,'Color',PARAMS.scol(PARAMS.icur,:),'FontWeight','bold');

% Uncomment the line below if you want the rectangle to plot on fish
% rectangle('Position',[DATA.XX1(MAIN.cnt),DATA.YY1(MAIN.cnt),DATA.rect_WIDTH(MAIN.cnt),DATA.rect_HEIGHT(MAIN.cnt)],'EdgeColor',PARAMS.scol(PARAMS.icur,:),'LineWidth',3)

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

clear cp1 cp2 x0 y0 
