function name = textname(files, current)

% 081018
% Helen Cai
% Generate text name to save file containing box metadata. 
% Called in detect_fish. Returns name, a string that should be the name of 
% the desired output file.  
% Input arguments:
%   files: a struct of .jpg files in the current directory
%   current: the index of the current .jpg file of choice



temp = erase(string(files(current).name), '.jpg');
name = strcat(files(current).folder, '/', temp, '.txt');


end

