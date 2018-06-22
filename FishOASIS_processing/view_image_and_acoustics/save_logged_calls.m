%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Save Logged Calls
%
% Saves the current LOG structure to a MAT file of the same naming scheme
% as the acoustic filenames (yymmdd_HHMMSS)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
save([LOG.filename,'_CallLog','.mat'],'LOG','-v7.3');