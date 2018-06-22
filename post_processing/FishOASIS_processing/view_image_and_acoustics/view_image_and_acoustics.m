%% View FishOASIS images and their associated acoustics
% Author: J Butler
% Original: Jan 2018, shamelessly stolen from image_processing written by C Pagniello
% Last Edit: Feb 2018 J Butler to add more functionality to the
% species-specific viewing and logging.
%

%% Create Image and Acoustic Windows
init_windows

%% Create Controls

% Control buttons
if ~isfield(MAIN,'control')
    
    init_controls
    
end

% Audio Parameters
init_audio_params

% Logger
init_logger

%% Get data associated with specific species
if PARAMS.spflag == 2
    
    get_species_specific_data
    
end
%% Get Image Path
if PARAMS.spflag ~= 3
    if PARAMS.spflag == 0 % To view all images
        
        view_all_images
        
    elseif PARAMS.spflag == 1 % To view images with only selected species
        
        view_subset_of_images
        
    end
end
%% Load Image

load_image

%% Load Acoustics

load_acoustics

%% Get Audio Date and Time

get_audio_date_and_time

%% Plot Image and Acoustics
% Image
draw_image

% Acoustics
draw_specgram

% Get the new parameters from the spectrogram
get_new_audio_parameters