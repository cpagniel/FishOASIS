%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Open Image
%
% Called from view_image_and_acoustics. Allows the user to select an image
% to open
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if PARAMS.spflag ~= 3
    % If user is viewing all images in a directory(s), no need to worry
    % about erasing the species-specific data
    
    [PARAMS.ifile,PARAMS.idir] = uigetfile([PARAMS.idir,'*.jpg'],'Select Image File');
    
    if PARAMS.ifile ~= 0
        
        PARAMS.drawflag = 1;
        PARAMS.spflag = 0;
        PARAMS.adate='enter date';
        PARAMS.atime='enter time';
        PARAMS.fft = '256';
        PARAMS.ovlap = '90';
        PARAMS.lfreq = '50';
        PARAMS.ufreq = '1000';
        PARAMS.ch = '1';
        PARAMS.clower = 'N/A';
        PARAMS.cupper = 'N/A';
        PARAMS.vol = '5';
        PARAMS.logger.val = 0;
        
        if ~isfield(PARAMS,'imdir')
            
            PARAMS.imdir.files = dir([PARAMS.idir,'\*.jpg']);
            PARAMS.adir.files = dir([PARAMS.idir,'\*.wav']);
            
            PARAMS.files = [];
            for ii = 1:length(PARAMS.imdir.files)
                PARAMS.files = [PARAMS.files;PARAMS.imdir.files(ii)];
            end
            
            PARAMS.afiles = [];
            for ii = 1:length(PARAMS.adir.files)
                PARAMS.afiles = [PARAMS.afiles;PARAMS.adir.files(ii)];
            end
            
        end
        
        PARAMS.ipath = [PARAMS.idir PARAMS.ifile];
        
        view_image_and_acoustics
        
    else
        uiwait(msgbox('User canceled image selection'))
        return
    end
    
else
    % User is looking through species-specific images, so want to select
    % images from a the subset list of images that pertain only to the
    % species of interest
    
    % Create a sublist of images within the directory
    PARAMS.subsublist = cell(size(PARAMS.files));
    for ii = 1:length(PARAMS.files)
        PARAMS.subsublist{ii} = PARAMS.files(ii).name;
    end
    
    % Create a list dialog of only the images that contain the species of
    % interest (inlcuding images from other directories)
    [BIN.s,BIN.v] = listdlg('PromptString','Select an image to load...',...
        'SelectionMode','single','OKString','Load',...
        'ListString',PARAMS.subsublist);
    
    if BIN.v > 0
        PARAMS.ifile = PARAMS.files(BIN.s).name;
        PARAMS.ipath = [PARAMS.idir PARAMS.ifile];
        view_image_and_acoustics
    else
        uiwait(msgbox('User canceled image selection'));
        return
    end
    
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
