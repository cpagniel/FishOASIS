%% Image Processing

clear
clc
close all

warning('off');

%% Create Main Window

MAIN.verno=' Image Processing v.0';
MAIN.figwidth = 0.80;
MAIN.figheight = 0.75;

MAIN.wbd='WindowButtonDown';
MAIN.wbm='WindowButtonMotion';
MAIN.wbu='WindowButtonUp';

MAIN.snsize = 12;
MAIN.visval = 'off';

MAIN.cnt = 0;

MAIN.hf1 = figure(1);

set(MAIN.hf1,'numb','off');
set(MAIN.hf1,'pointer','crosshair','name',MAIN.verno);
set(MAIN.hf1,'units','norm','pos',[.10 .10 MAIN.figwidth MAIN.figheight],'menubar','none');

PARAMS.idate='enter date';
PARAMS.itime='enter time';
PARAMS.iname='enter filename';
PARAMS.iqual='enter picture quality';
PARAMS.comments='enter comments here';

%% Create Controls

% File Menu

MAIN.control.hmen3 = uimenu(MAIN.hf1,'lab','File');
MAIN.control.hmen3a=uimenu(MAIN.control.hmen3,'lab','Save DATA','sep','on','call','savedata;disp(''Data has been saved.'')');
MAIN.control.hmen3b=uimenu(MAIN.control.hmen3,'lab','SAVE DATA and Select to Next Image','call','savedatanext;disp(''Data has been saved.'')');
MAIN.control.hmen3c=uimenu(MAIN.control.hmen3,'lab','Quit','call','delete(MAIN.hf1)');

% Image Parameters
MAIN.control.hsetparams=uicontrol(MAIN.hf1,'style','push','un','n','pos',[.900 .806 .100 .024],...
    'str','Image Parameters','call','setparams');
PARAMS.hidate=uicontrol(MAIN.hf1,'style','edit','un','n','pos',[.915 .774 .085 .032], ...
    'str',PARAMS.idate,'foreg',[0 0 1],'backg',[1 1 1]);
MAIN.control.hidatex=uicontrol(MAIN.hf1,'style','text','un','n','pos',[.892 .774 .023 .032], ...
    'str','Date','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hitime=uicontrol(MAIN.hf1,'style','edit','un','n','pos',[.915 .742 .085 .032], ...
    'str',PARAMS.itime,'foreg',[0 0 1],'backg',[1 1 1]);
MAIN.control.hitimex=uicontrol(MAIN.hf1,'style','text','un','n','pos',[.892 .742 .023 .032], ...
    'str','Time','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hiname=uicontrol(MAIN.hf1,'style','edit','un','n','pos',[.915 .710 .085 .032], ...
    'str',PARAMS.iname,'foreg',[0 0 1],'backg',[1 1 1]);
MAIN.control.hinamex=uicontrol(MAIN.hf1,'style','text','un','n','pos',[.885 .710 .030 .032], ...
    'str','Filename','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hiqual=uicontrol(MAIN.hf1,'style','edit','un','n','pos',[.915 .678 .085 .032], ...
    'str',PARAMS.iqual,'foreg',[0 0 1],'backg',[1 1 1]);
MAIN.control.hiqualx=uicontrol(MAIN.hf1,'style','text','un','n','pos',[.870 .678 .045 .032], ...
    'str','Image Quality','foreg',[0 0 0],'backg',[.8 1 1]);

% Status Bar
MAIN.hstatus10=uicontrol(MAIN.hf1,'style','text','un','n','pos',[.125 .0 .324 .020], ...
   'foreg',[0 0 0],'backg',[1 1 .75],'str','species');

% Comments
MAIN.control.hicommentsx=uicontrol(MAIN.hf1,'style','text','un','n','pos',[0.7 0.4 .050 .032], ...
    'str','Comments','foreg',[0 0 0],'backg',[.8 1 1]);
PARAMS.hicomments=uicontrol(MAIN.hf1,'style','edit','un','n','pos',[0.7 0.01 0.3 0.38], ...
    'str',PARAMS.comments,'foreg',[0 0 1],'backg',[1 1 1]);

%% Get Image Path

[PARAMS.ifile,PARAMS.idir] = uigetfile([pwd '\*.jpg'],'Select Image File');
PARAMS.ipath = [PARAMS.idir PARAMS.ifile];

%% Load Image

DATA.IMG = imread(PARAMS.ipath);

[MAIN.iheight,MAIN.iwidth] =size(DATA.IMG);
MAIN.aspratio = MAIN.iwidth/MAIN.iheight;

MAIN.scrsize = get(0,'screensize');
MAIN.xmen = MAIN.figwidth*MAIN.scrsize(3);
MAIN.ymen = MAIN.figheight*MAIN.scrsize(4);
MAIN.imagepart = MAIN.ymen/MAIN.xmen;

MAIN.ha1 = axes('units','norm','pos',[0 0.02 0.98*MAIN.imagepart 0.98]);

MAIN.hi1 = image(DATA.IMG);

set(MAIN.ha1,'dataaspectratio',[1 1 1]);
set(MAIN.ha1,'xgr','on','ygr','on');
set(MAIN.ha1,'XTickLabel',[])
set(MAIN.ha1,'YTickLabel',[])

%% Thumbnail

MAIN.ha2 = axes('un','norm','pos',[(MAIN.xmen-150)/MAIN.xmen (MAIN.ymen-250/MAIN.aspratio)/MAIN.ymen 140/MAIN.xmen (240/MAIN.aspratio)/MAIN.ymen]);

MAIN.hi2 = image(DATA.IMG);

set(MAIN.ha2,'dataaspectratio',[1 1 1]);
set(MAIN.ha2,'xgr','on','ygr','on');

MAIN.xlim0 = get(MAIN.ha1,'xlim');
MAIN.ylim0 = get(MAIN.ha1,'ylim');

axes(MAIN.ha2);

set(MAIN.ha2,'XTickLabel',[])
set(MAIN.ha2,'YTickLabel',[])

MAIN.xxx=[MAIN.xlim0(1) MAIN.xlim0(1) MAIN.xlim0(2) MAIN.xlim0(2) MAIN.xlim0(1)];
MAIN.yyy=[MAIN.ylim0(1) MAIN.ylim0(2) MAIN.ylim0(2) MAIN.ylim0(1) MAIN.ylim0(1)];

MAIN.hl1=line(MAIN.xxx,MAIN.yyy,'color',[0 1 0],'linewidth',4,'erasemode','none');

axes(MAIN.ha1);

%% Load Species

load('species.mat');

PARAMS.scode = scode;
PARAMS.scol = scol;
PARAMS.sfull = sfull;
PARAMS.snumb = snumb;

clear scode scol sfull snumb

%% Create Species Buttons

[PARAMS.nspec,~] = size(PARAMS.sfull);

MAIN.hu1 = zeros(1,PARAMS.nspec);
MAIN.hu3 = zeros(1,PARAMS.nspec);
DATA.COUNT = zeros(1,PARAMS.nspec);

icnt = 0;
PARAMS.icntmax = 50;
x0 = 0.60; y0 = 1.00;

for i = 1:PARAMS.nspec
    
    icnt = icnt + 1;
    if icnt==PARAMS.icntmax
        icnt = 1;
        x0 = x0 + 0.10;
        y0 = 1.00;
    end
    y0 = y0 - .02;
    
    if i < 20
        MAIN.hu1(i) = uicontrol(MAIN.hf1,'un','n','style','push','pos',[x0  y0 .06 .02], ...
            'string',[num2str(PARAMS.snumb(i)) ' ' char(PARAMS.scode(i,:))],'foregroundcolor','w', ...
            'backgroundcolor',PARAMS.scol(i,:), 'tag','hu','user',i,'callback','sclick;');

        MAIN.hu3(i) = uicontrol(MAIN.hf1,'un','n','style','tex','pos',[x0+0.06 y0 .03 .02], ...
            'str',num2str(DATA.COUNT(i)),'tag','hu','fontsize',9,'fontweight','b',...
            'backgroundcolor',PARAMS.scol(i,:),'foregroundcolor','w');
    elseif i >= 20
        MAIN.hu1(i) = uicontrol(MAIN.hf1,'un','n','style','push','pos',[x0  y0 .06 .02], ...
            'string',[num2str(PARAMS.snumb(i)) ' ' char(PARAMS.scode(i,:))], ...
            'backgroundcolor',PARAMS.scol(i,:), 'tag','hu','user',i,'callback','sclick;');

        MAIN.hu3(i) = uicontrol(MAIN.hf1,'un','n','style','tex','pos',[x0+0.06 y0 .03 .02], ...
            'str',num2str(DATA.COUNT(i)),'tag','hu','fontsize',9,'fontweight','b',...
            'backgroundcolor',PARAMS.scol(i,:));
    end
    
end

clear icnt x0 y0 i

%% Get Image Parameters

PARAMS.hidate=uicontrol(MAIN.hf1,'style','edit','un','n','pos',[.915 .774 .085 .032], ...
    'str',datestr(datenum(PARAMS.ifile(1:6),'yymmdd'),'mm/dd/yy'),'foreg',[0 0 1],'backg',[1 1 1]);
PARAMS.hitime=uicontrol(MAIN.hf1,'style','edit','un','n','pos',[.915 .742 .085 .032], ...
    'str',datestr(datenum(PARAMS.ifile(8:13),'hhmmss'),'hh:mm:ss'),'foreg',[0 0 1],'backg',[1 1 1]);
PARAMS.hiname=uicontrol(MAIN.hf1,'style','edit','un','n','pos',[.915 .710 .085 .032], ...
    'str',PARAMS.ifile,'foreg',[0 0 1],'backg',[1 1 1]);

%% Set Processing Off Until Image Parameters Set

set(MAIN.hf1,MAIN.wbd,'',MAIN.wbm,'',MAIN.wbu,'');
set(MAIN.hu1,'en','off')

