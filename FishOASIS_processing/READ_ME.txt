%%%%%%%%%%%%%%%%%%%% READ ME %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
This toolbox provides functionality to process image and 
acoustic data recorded by FishOASIS. It contains four main
programs: a GUI to load images and count fish within those
images (image_processing_v2), a script to concatenate all 
fish count data from a deployment into a single data file
(Grab_image_processing_data), a script to extract acoustic 
data based on recorded image time (grab_acoustics), and a 
GUI to view images and their associated acoustic data to log
fish calls (view_image_and_acoustics).

Simply run FishOASIS_processing from the MATLAB command window, 
a button group will open and allow the user to select which 
processing routine to run. This button group is persistent, so
that after one routine completes, another can be selected to 
continue data processing.

FishOASIS Processing Toolbox
Version 1.0
Jan. 30, 2018
Authors: C Pagniello and J Butler