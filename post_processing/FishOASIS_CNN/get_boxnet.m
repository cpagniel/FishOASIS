% 071018
% Helen Cai
% Load previously trained boxnet

function current_boxnet = get_boxnet()
    load_boxnet_version = inputdlg('Enter the version # of boxnet you would like to load.');
    if isempty(load_boxnet_version{1}) | isempty(load_boxnet_version)
        warndlg('No previous version of the network will be loaded. Load an old network or train a new one.', '');
        current_boxnet = 0;
    else
        load_boxnet_version = strcat(pwd, '\boxnet', '\draw_boxes_v', string(load_boxnet_version));
       
        load(load_boxnet_version, 'detector');
%       load(load_boxnet_version, boxnet);
%       current_boxnet = boxnet;
        current_boxnet = detector;
        
    end
end