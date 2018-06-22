function runFishOASIS(~,sel)
if sel == 1
    image_processing_v3
elseif sel == 2
    Grab_image_processing_data
elseif sel == 3
    grab_acoustics
elseif sel == 4
    evalin('base','view_image_and_acoustics')
elseif sel == 5
    evalin('base','analyze_fish_count_data')
end
end
