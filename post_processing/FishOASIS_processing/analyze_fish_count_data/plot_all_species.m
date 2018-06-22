%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Plot All Species
%
% Called from analyze_fish_count_data, this script plots all species
% presnt in the fish count data.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot allcounts Variable into the Axes
stem(h1.a,time,allcounts,'marker','none','linewidth',1);
title(['All species counts for ',datestr(min(time),2),' to ',datestr(max(time),2),' deployment']);
xticks(xtime); dateaxis('x',15);

% Plot patches to show no-effort times
hold(h1.a)
for ii = 1:length(fieldnames(iDATA))+1
    if ii == 1 % for the first patch
        h1.patch.(['p',num2str(ii)]) = ...
            patch([xtime(1) iDATA.day1.date(1) iDATA.day1.date(1) xtime(1)],...
            [min(get(get(h1.a,'yaxis'),'limits')) min(get(get(h1.a,'yaxis'),'limits')) ...
            max(get(get(h1.a,'yaxis'),'limits')) max(get(get(h1.a,'yaxis'),'limits'))],...
            [.1 .1 .1],... % for dark grey
            'facealpha',0.3,'edgecolor','none');
    elseif ii > 1 && ii < length(fieldnames(iDATA))+1
        h1.patch.(['p',num2str(ii)]) = ...
            patch([iDATA.(['day',num2str(ii-1)]).date(end), iDATA.(['day',num2str(ii)]).date(1),...
            iDATA.(['day',num2str(ii)]).date(1),iDATA.(['day',num2str(ii-1)]).date(end)],...
            [min(get(get(h1.a,'yaxis'),'limits')) min(get(get(h1.a,'yaxis'),'limits')) ...
            max(get(get(h1.a,'yaxis'),'limits')) max(get(get(h1.a,'yaxis'),'limits'))],...
            [.1 .1 .1],... % for dark grey
            'facealpha',0.3,'edgecolor','none');
    elseif ii == length(fieldnames(iDATA))+1
        h1.patch.(['p',num2str(ii)]) = ...
            patch([iDATA.(['day',num2str(ii-1)]).date(end), xtime(end),...
            xtime(end),iDATA.(['day',num2str(ii-1)]).date(end)],...
            [min(get(get(h1.a,'yaxis'),'limits')) min(get(get(h1.a,'yaxis'),'limits')) ...
            max(get(get(h1.a,'yaxis'),'limits')) max(get(get(h1.a,'yaxis'),'limits'))],...
            [.1 .1 .1],... % for dark grey
            'facealpha',0.3,'edgecolor','none');
    end
end

hold(h1.a)
    
    
    
    
    
%% Update Plotted Species Dialog
species = 'All Species';

h1.sptext = uicontrol(h1.f,'style','text','string','Plotted Species',...
    'units','norm','position',[.88 .465 .12 .05],'fontsize',12);

h1.spdisp = uicontrol(h1.f,'style','listbox','units','norm','pos',[.88 .37 .12 .1], ...
    'str',species,'foreg',[0 0 0],'backg',[1 1 1]);