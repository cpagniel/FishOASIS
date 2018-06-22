%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Set Call Name
%
% Called by log_calls to set the name of an unknown call
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ii = 1:length(fieldnames(MAIN.log.call))
    h = {['h',num2str(ii)]};
    if MAIN.log.call.(h{1}).Value == 1
        break
    end
end

if strcmp(PARAMS.log.call.(h{1}).name,'Unknown Call')
    
    DLG.prompt = 'Enter name for unknown call'; DLG.ttl ='Enter Name';
    DLG.in = inputdlg(DLG.prompt,DLG.ttl,1,{'Enter Name'});
    
    if ~isempty(in)
        
        set(MAIN.log.call.(h{1}),'string',in{1});
        PARAMS.log.call.(h{1}).name = in{1};
        PARAMS.log.call.(h{1}).callflag = 1;
        MAIN.log.call.(h{1}).UserData = 1;
        
    else
        uiwait(msgbox('New call name not set'));
        PARAMS.log.call.(h{1}).callflag = 0;
        return
    end
    
else
    return
end



