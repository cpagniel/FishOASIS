% 071018
% Helen Cai
% Load previously trained fishnet

function current_fishnet = get_fishnet()
    load_fishnet_version = inputdlg('Enter the version # of fishnet you would like to load.');
    if isempty(load_fishnet_version{1}) | isempty(load_fishnet_version) 
        warndlg('No previous version of the network will be loaded. Load an old network or train a new one.', '');
        current_fishnet = 0;
    else
        load_fishnet_version = strcat(pwd, '/fishnet', '/fishnet_v', string(load_fishnet_version));
       
        load(load_fishnet_version, 'fishnet')
        current_fishnet = fishnet;
        
    end
end