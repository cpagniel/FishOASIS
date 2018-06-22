%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Analyze Fish Count Data
%
% This script allows the user to visualize fish count data from the
% image_processing_v2 output and concatenated by grab_image_processing_data.
% Users can select to view timeseries of all species or a subset of species.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load Concatenated Fish Count Data
[fname pname] = uigetfile('*.mat','Select Concatenated Fish Count Data');

if fname ~= 0
    load([pname fname]);
else
    uiwait(msgbox('User canceled file selection - program terminates'));
    return
end

allcounts = []; time = [];
for ii = 1:length(fieldnames(iDATA))
    d{ii} = ['day' num2str(ii)];
    allcounts = [allcounts,sum(iDATA.(d{ii}).count')];
    time = [time;iDATA.(d{ii}).date];
end
species = '';

x1 = floor(iDATA.day1.date(1));
xtime = x1:.5:(x1+length(fieldnames(iDATA)));

%% Create Figure Window
h1.f = figure('name','Species Abundance Plots',...
    'units','norm','numbertitle','off',...
    'outerposition',[0 0.04 1 .96],...
    'CloseRequestFcn','closereq;clear');

h1.a = axes(h1.f,...
    'xtick',[],'xticklabel',{},...
    'ytick',[],'yticklabel',{},...
    'position',[.05 .1 .82 .85]);

%% Create Persistent Buttons
h1.pb1 = uicontrol(h1.f,'style','pushbutton','string','Select Species',...
    'units','norm','position',[.9 .05 .1 .07],...
    'callback','getspecies');

h1.pb2 = uicontrol(h1.f,'style','pushbutton','string','Plot Selected Species',...
    'units','norm','position',[.9 .13 .1 .07],...
    'callback','plot_selected_species');

h1.pb3 = uicontrol(h1.f,'style','pushbutton','string','Save Species Selection and Times',...
    'units','norm','position',[.9 .21 .1 .07],...
    'callback','save_species_selection');

h1.pb4 = uicontrol(h1.f,'style','pushbutton','string','Plot All Species',...
    'units','norm','position',[.9 .29 .1 .07],...
    'callback','plot_all_species');

%% Create Species Display Box
h1.sptext = uicontrol(h1.f,'style','text','string','Plotted Species',...
    'units','norm','position',[.88 .465 .12 .05],'fontsize',12);

h1.spdisp = uicontrol(h1.f,'style','listbox','units','norm','pos',[.88 .37 .12 .1], ...
    'str',species,'foreg',[0 0 0],'backg',[1 1 1]);



