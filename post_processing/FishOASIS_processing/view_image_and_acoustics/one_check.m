%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% One Check
%
% Called from log_calls, allows only one call type to be selected
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function one_check(~,d)
for ii = 1:length(MAIN.log.call)
    h = {'h',num2str(ii)};
    if MAIN.log.call.(h{1}).UserData == d
        break
    end
end

MAIN.log.activecall = MAIN.log.call.(h{1}).String;