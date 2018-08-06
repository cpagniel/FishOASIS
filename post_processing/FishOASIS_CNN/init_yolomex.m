% 080618
% Helen Cai
%
% Call this script from the GUI to intiate application of YOLO object 
% recognition to FishOASIS data set.  
% Dependent on git from https://github.com/ignacio-rocco/yolomex
% and a set of custom weights that must be trained in order to recognize
% fish. 

addpath('yolomex')
cd('yolomex')

datacfg = fullfile(pwd,'darknet/cfg/coco.data');
cfgfile = fullfile(pwd,'darknet/cfg/tiny-yolo.cfg');

% Import weights to be used for detection. Modify this line once fish are
% added to the detection classes. 
weightfile = fullfile(pwd,'tiny-yolo.weights');

% Initialize YOLO. Change threshold values to adjust sensitivity. 
yolomex('init',datacfg,cfgfile,weightfile)
handles.threshold = 0.01;
handles.hier_threshold = 0.01;



cd('..')
