# Automated Post-Processing

This folder contains a series of Matlab scripts to detect, classify, and count fish in images. Classification relies on a neural network that is generated and trained by the user. 

## Training the neural network

Training the neural network (fishnet) is dependent on a training set of RGB images that are resized to 227x227 pixels. The training images should be placed in subdirectories that are labeled with the class name:

	/ trainingset
		/ class 1 name
			image1
			image2
			...
		/ class 2 name
			image1
			image2
			...
		/ class 3 name
			image1
			image2
			...

To train the neural network, run fishnet/train_classifier from Matlab.  

## Running automated detection

From Matlab, open run_detections. Change the boolean flags at the top of the script to change the tasks that will be run. Run the script and follow the prompts. 

Running this script generates several text files: 
	* one text file for each image, containing a list of detections
	* log.txt, recording all output to Matlab command window
	* counts.txt, which counts the instances of each class detected based on the output of the log 

## Dependencies

This project is dependent on the following add-ons in Matlab:

	* Image Processing Toolbox
	* Neural Network Toolbox