%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Log Calls
%
% Called by toggling "Log Calls" button, this script allows the user to log
% calls using the mouse to draw a rectangle around the call to grab start
% time, end time, lower frequency, and upper frequency
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global MAIN
if get(MAIN.control.hinitlogger,'Value') == 1
    % Show that logger is running
    set(MAIN.control.hinitlogger,'BackgroundColor',[.2 .8 .2]);
    PARAMS.logger.val = 1;
    PARAMS.log = [];
    % Create logging window and button group
    MAIN.hf3 = figure(3);
    set(MAIN.hf3,'numb','off','name','Logging Parameters',...
        'units','norm','pos',[0.3812 0.615 MAIN.lfigwidth MAIN.lfigheight],...
        'menubar','none');
    
    MAIN.log.bg = uibuttongroup(MAIN.hf3);
    
    % Create controls within the window
    MAIN.log.calltitle = uicontrol(MAIN.log.bg,'un','n','style','text',...
        'pos',[.1 .88 .2 .1],'str','Call Types','foreg',[0 0 0],'backg',[.6 .6 1],...
        'fontsize',10,'fontweight','bold');
    
    if ~isfield(PARAMS.log,'call')
        PARAMS.log.call.h3.name = 'Unknown Call';
        PARAMS.log.call.h4.name = 'Unknown Call';
        PARAMS.log.call.h5.name = 'Unknown Call';
        
        PARAMS.log.call.h3.callflag = 0;
        PARAMS.log.call.h4.callflag = 0;
        PARAMS.log.call.h5.callflag = 0;
    end
    
    if ~isfield(PARAMS.log,'count')
        PARAMS.log.count.h1 = 0;
        PARAMS.log.count.h2 = 0;
        PARAMS.log.count.h3 = 0;
        PARAMS.log.count.h4 = 0;
        PARAMS.log.count.h5 = 0;
        PARAMS.log.current.start = 'N/A';
        PARAMS.log.current.end = 'N/A';
        PARAMS.log.current.upper = 'N/A';
        PARAMS.log.current.lower = 'N/A';
    end
    
    MAIN.log.call.h1=uicontrol(MAIN.log.bg,'style','radio','un','n',...
        'pos',[.1 .8 .2 .1],'str','300-500 Hz Call','foreg',[0 0 0],'backg',[.8 1 1],...
        'call','get_call_info2','userdata',1);
    set(MAIN.log.call.h1,'Value',0); % So nothing is clicked when buttons are created
    
    
    MAIN.log.call.h2=uicontrol(MAIN.log.bg,'style','radio','un','n',...
        'pos',[.1 .7 .2 .1],'str','80-100 Hz Call','foreg',[0 0 0],'backg',[1 .8 1],...
        'call','get_call_info2','userdata',1);
   
    
    MAIN.log.call.h3=uicontrol(MAIN.log.bg,'style','radio','un','n',...
        'pos',[.1 .6 .2 .1],'str',PARAMS.log.call.h3.name,'foreg',[0 0 0],'backg',[1 1 .8],...
        'call','set_call_name;get_call_info2','userdata',PARAMS.log. call.h3.callflag);
    
    
    MAIN.log.call.h4=uicontrol(MAIN.log.bg,'style','radio','un','n',...
        'pos',[.1 .5 .2 .1],'str',PARAMS.log.call.h4.name,'foreg',[0 0 0],'backg',[.7 1 .7],...
        'call','set_call_name;get_call_info2','userdata',PARAMS.log.call.h4.callflag);
    
    
    MAIN.log.call.h5=uicontrol(MAIN.log.bg,'style','radio','un','n',...
        'pos',[.1 .4 .2 .1],'str',PARAMS.log.call.h5.name,'foreg',[0 0 0],'backg',[.8 .8 1],...
        'call','set_call_name;get_call_info2','userdata',PARAMS.log.call.h5.callflag);
    
    % Set-up and display previously logged call info
    display_call_parameters
    
elseif get(MAIN.control.hinitlogger,'Value') == 0
    % Show that logger is off
    set(MAIN.control.hinitlogger,'BackgroundColor',[.94 .94 .94]);
    PARAMS.logger.val = 0;
    close(MAIN.hf3);
end