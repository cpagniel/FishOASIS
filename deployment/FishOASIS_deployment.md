# Preparation for FishOASIS Camera Deployment 

## Creating Cement Stand to Deploy Camera

## Camera Settings

Instructions on how to set camera settings can be found [here](/deployment/FishOASIS_camera_settings.md).

## Attach Camera Dome and Extension to Ikelite Housing

Grease the two O-rings of the 3.5 inch extension. Screw the extension into the camera dome. Use the four port locks to attached the extension and dome port to the front of the Ikelite housing.

<p align="center">
<img src="/hardware/images/IMG_0181.jpg" width="50%">
</p>

## Inserting Electronics into Ikelite Housing

Insert dummy battery into camera. Tape over the screen of the camera to protect it from scratching from the RPi.

<p align="center">
<img src="/hardware/images/IMG_0165.jpg" width="50%">
</p>

Connect USB hub to RPi. Use right angle micro USB to USB to connect the camera to the USB hub. Insert 3 USB drives into the USB hub, one directly and two using the USB extension cables.

<p align="center">
<img src="/hardware/images/IMG_0162.jpg" width="50%">
</p>

Connect the male end of the Molex connector attached to the dummy battery of the camera to the female end of the Molex connector attached to the bulkhead connector in the Ikelite housing. 

<p align="center">
<img src="/hardware/images/IMG_0171.jpg" width="50%">
</p>

Insert the camera into the camera tray in the Ikelite housing. Place the USB hub on the lefthand side of the Ikelite housing and the RPi behind the camera. Plug the right angle micro USB attached to the bulkhead connector into the RPi.

<p align="center">
<img src="/hardware/images/IMG_0143.jpg" width="50%">
</p>

Grease the O-ring on the back plate of the Ikelite housing. Close the housing with the 3 buckles.

## Battery Pack

To prepare the battery pack for deployment, insert 48 D cells into the battery holders and connect the male end of the Molex connector attached to the battery holders to the female end of the Molex connector. Place the battery holders, wiring and step-down converters into the PVC tube. Grease the large O-ring of the socket-connect end of the union connector glued to the PVC pipe, place the acrylic disk with the bulkhead connector on top of it and screw on the threaded union connector center. Use a strap wrench to tighten the connection.

<p align="center">
<img src="/hardware/images/IMG_0126.jpg" width="40%">
</p>

## Connect Battery Pack to Ikelite Housing using In-Line Connector

Fill the holes of the in-line connector with a bit of Molykote. 

<p align="center">
<img src="/hardware/images/IMG_0129.jpg" width="40%">
</p>

Attach the in-line connector to the bulkhead on the battery pack first. Then, attach the other end on the in-line connector to the bulkhead on the Ikelite housing. As soon as a connection is made with the Ikelite housing (even if the in-line connector is not fully seated), the RPi and camera should power on and start a cycle (one cycle = RPi startup, play calibration tones via miniature speaker, take 12 images,  pause for 30 seconds, take 12 images - i.e., 1 image every 5 seconds, RPi shutdown). Note, the camera remains on at all times. However, when it is in sleep mode (i.e., which activates about 5 minutes after the last image was taken), no power is consumed.

<p align="center">
<img src="/hardware/images/IMG_0184.jpg" width="50%">
</p>
