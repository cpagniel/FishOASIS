function bkg = makefilter(files, current)

% 080918
% Helen Cai
% Generate a value of background noise for image data. Takes the moving
% average of 10 files around the current file. Returns bkg, a 1D matrix
% that represents image data. 
% Input arguments:
%   files: a struct of .jpg files in the current directory
%   current: the index of the current .jpg file of choice

% Generate a sliding window of 7 file names
window = cell(1,7);
for i = 1:7
    if length(files) - current < 4
        % At the end
        k = length(files) + 1 - i;
    elseif current < 4
        % At the beginning
        k = i;
    else
        % In the middle
        k = i - 3 + current;
    end
    window(i) = {files(k).name};
end

% Open and sum files
pixels = 0;
for i = 1:7
    I = imread(char(window(i)));
    pixels = pixels + I;
end

% Take average and return
bkg = pixels / 3;
end

