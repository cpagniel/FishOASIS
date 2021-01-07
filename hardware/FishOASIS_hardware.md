# FishOASIS Camera Hardware Construction
Instructions for hardware construction for FishOASIS camera.

[Battery Pack](#battery-pack)  
[In-Line Connector](#in-line-connector-between-battery-pack-and-ikelite-housing)  
[Ikelite Housing](#ikelite-housing)  
[Modifications to Electronics](#modifications-to-electronics)  
[Cement Stand for Deployment](#creating-cement-stand-to-deploy-camera)

<p align="center">
<img src="/hardware/images/Camera_System.png" width="50%">
</p>

[Click here](link to xls file in github) to download the parts list for FishOASIS camera.

## Battery Pack

### Gluing PVC Battery Housing

Cut the PVC pipe into a 30-inch long tube using a hacksaw or a PVC pipe cutter. 

Prime each end of the cut pipe. On one end, glue the PVC cap using the cement. On the other end, glue the union connector. A tutorial on how to prime and glue a PVC pipe can be found [here](https://www.youtube.com/watch?v=8kKVIoUhyYA&ab_channel=BenjaminSahlstrom).

Once glued, your PVC tube with end cap and union connector should look like this:

<p align="center">
<img src="/hardware/images/pvc_tube.png">
</p>

### Drill and Tap Hole for Bulkhead Connector into Acrylic Disk

Using a benchtop drill press, drill a 25/64 hole into the center of the acrylic disk. Then, run a 7/16-20 tap through the pre-drilled hole. A tutorial on how to drill and tap a hole using a benchtop drill press can be found [here](https://www.youtube.com/watch?v=EGhjsAOjfzU&ab_channel=ElectricChronicles).

Grease the O-ring on the bulkhead connector using a silicone-based grease and screw the bulkhead connector into place as tight as possible. The acrylic disk with bulkhead connector should look like this:

<p align="center">
<img src="/hardware/images/IMG_0113.jpg" width="30%"> <img src="/hardware/images/IMG_0114.jpg" width="30%"> <img src="/hardware/images/IMG_0115.jpg" width="30%"> 
</p>

More information about the bulkhead connector can be found [here](https://www.macartney.com/what-we-offer/systems-and-products/connectors/subconn/subconn-micro-circular-series/subconn-micro-circular-2-3-4-5-6-and-8-contacts-and-g2-2-3-and-4-contacts/).

### Attach Molex Connector to Bulkhead Connector

Strip the ends of the four wires attached to the bulkhead connector. Crimp a power connector pin (i.e., male end) to each of the four wires. 

<p align="center">
<img src="/hardware/images/IMG_0188.jpg" width="40%"> <img src="/hardware/images/IMG_0189.jpg" width="40%">
</p>

Insert the crimped wires into the female end of the 6-pin Molex connector using the following pin layout. Note, the wires on the bulkhead connector are labeled with numbers and correspond to the numbering used below. 

<p align="center">
<img src="/hardware/images/IMG_0117.jpg" width="40%">
</p>

A tutorial on how to crimp the power connector to the wires and how to install a Molex connector can be found [here](https://www.progressiveautomations.com/blogs/how-to/how-to-install-and-remove-molex-connectors). A short video can be found [here](https://www.youtube.com/watch?v=h4xdpWOKBr0&feature=youtu.be&ab_channel=SteinAir) as well.

### Wiring the Battery Pack

To build the 720 Wh battery pack, you will need to solder wires together and cover the connections with heat shrink tubing. Here are a few tutorials on [how to work with wires](https://learn.sparkfun.com/tutorials/working-with-wire) (including stripping, splicing, etc.), [how to solder](https://www.makerspaces.com/how-to-solder/) and [how to use heat shrink tubing](https://www.ifixit.com/Guide/How+to+Use+Heat+Shrink+Tubing/64041). Here is also a brief tutorial on [working with batteries](https://www.instructables.com/hack-that-battery-pack-also-a-small-lesson-in-/).

First, connect 4 battery holders (i.e., 12 D cells) in series by soldering the positive end of one battery holder to the negative end of another (i.e., red to black wire). Cover these connections with heat shrink tubing. Repeat this an additional 3 times. Secure adjacent battery holders with small zip ties.

<p align="center">
<img src="/hardware/images/battery_holder_series.png">

<img src="/hardware/images/IMG_3554.JPG" width="40%">
</p>

Stack two lines of 4 battery holders as shown below:

<p align="center">
<img src="/hardware/images/battery_stack.png">
</p>

Connect the two lines with small screws and washers through the small openings at the end of each battery holders as shown above.

Place the two stacks (i.e., two lines of 4 battery holders stacked vertically) side-by-side and tape them together as follows:

<p align="center">
<img src="/hardware/images/battery_all_stack.png">
</p>

Your battery pack should now look like this:

<p align="center">
<img src="/hardware/images/battery_combine.png" width="50%">

<img src="/hardware/images/real_battery.jpg">
</p>

On one end of the battery pack, solder and heat shrink together the two negative (i.e., black) wires with a third 20 AWG black wire that is long enough to reach the other end of the battery pack. Repeat this for the positive (i.e., red) wires. This combines two lines of battery holders (i.e., 2 x 12 D cells) in parallel.

<p align="center">
<img src="/hardware/images/battery_parralel.png" width="50%">
</p>

At the other end of the battery pack, solder and heat shrink together the two negatives (i.e., black) wires from the battery holders, the third 20 AWG long black wire from the opposite end of the battery pack and two additional 20 AWG black wires at least 12 inches long. This will connect all four lines of battery holders (i.e., 4 x 12 D cells) in parallel and will provide two outputs to be connected to two step-down converters, respectively. Repeat this for the positive (i.e., red) wires. 

<p align="center">
<img src="/hardware/images/battery_wiring_all.png" width="50%"> <img src="/hardware/images/IMG_3555.JPG" width="30%">
</p>

Pair one of the black wires with one of the red wires. These two pairs of wires will be the input into two step-down converters. Solder the black wire from the battery pack to the IN - input of the step-down converter. Solder the corresponding red wire from the battery pack to the IN + input of the step-down converter. 

<p align="center">
<img src="/hardware/images/step-down_converter.jpg">
</p>

Solder a red wire to the OUT + output of the step-down converter. Solder a black wire to the OUT - output of the step-down converter. Crimp a power connector sleeve (i.e., female end) to the other end of these wires. 

Set the voltage of one step-down converter to 5.2 V. [Here is a short video on how to adjust the voltage of the step-down converter](https://www.youtube.com/watch?v=QPntXt8Ea3s&ab_channel=POWERGEN). Insert the red crimped wire into position 3 of the male end of the 6-pin Molex connector and the black crimped wire into position 4 using the following pin layout. This is to power the Raspberry Pi single-board computer.

<p align="center">
<img src="/hardware/images/battery_molex_layout.jpg" width="40%">
</p>

Repeat the last two steps above for the second step-down converter. However, this time, set the voltage of the step-down converter to 7.9 V. Insert the red crimped wire into position 1 and the black crimped wire into position 2 of the male end of the 6-pin Molex connector. This is to power the Sony alpha 7s ii camera. 

To test the wiring of the battery pack, fill one line of 4 battery holders with 12 D cells. The lights on both step-down converters should be illuminated as shown below. You can measure the output voltage from each step-down converter with a multimeter to confirm that they are 5.2 V and 7.9 V, respectively. Repeat this for all four lines of battery holders individually.

<p align="center">
<img src="/hardware/images/IMG_0105.jpg" width="40%">
</p>

## In-Line Connector Between Battery Pack and Ikelite Housing

Cut an 8-inch long clear PETG tube and drill two holes into the tube:

<p align="center">
<img src="/hardware/images/IMG_0136.jpg" width="40%">
</p>

Thread a female locking sleeve onto each micro in-line connector. Thread the cut clear PETG tube onto one of the micro in-line connector.

<p align="center">
<img src="/hardware/images/IMG_0131.jpg" width="40%">
</p>

Solder the four wires of the micro in-line connectors together based on color (i.e., white to white, green to green, etc.) and cover the soldered wires with heat shrink tubing. Move the clear PETG tube over the heat shrink tubing and tape the ends of the clear PETG tube to the micro in-line connector. 

<p align="center">
<img src="/hardware/images/IMG_0137.jpg" width="40%"> <img src="/hardware/images/IMG_0138.jpg" width="40%">
</p>

Check for electrical continuity between the connections. 

Pour the cable insulating resin flame retardant (also known as scotchcast) into the clear PETG tube. Here is a tutorial on [how to use resin](https://www.youtube.com/watch?v=_HNsqACdmoc&feature=youtu.be). The resin will waterproof this connection between the micro in-line connectors. Cover the in-line connector with abrasion-resistant expandable sleeving, covering the ends with electrical tape to keep the sleeving in place.

<p align="center">
<img src="/hardware/images/IMG_0130.jpg" width="40%">
</p>

Check again for electrical continuity between the connections.

One end of the in-line connector will be the connection to the battery pack while the other end will be the connection to the Ikelite housing. Before connecting the female in-line connector to the male bulkhead connector, add Molykote to the female in-line connector.

<p align="center">
<img src="/hardware/images/IMG_0139.jpg" width="40%">
</p>

## Ikelite Housing

### Drill and Tap Hole for Bulkhead Connector into Ikelite Housing

Using a benchtop drill press, drill a 25/64 hole into the flat top of the Ikelite Housing. Then, run a 7/16-20 tap through the pre-drilled hole. Grease the O-ring on the bulkhead connector using a silicone-based grease and screw the bulkhead connector into place as tight as possible.

<p align="center">
<img src="/hardware/images/IMG_0145.jpg" width="30%"> <img src="/hardware/images/IMG_0148.jpg" width="30%"> <img src="/hardware/images/IMG_0157.jpg" width="30%">
</p>

### Attach Molex Connector to Bulkhead Connector

Strip the ends of the four wires attached to the bulkhead connector. Crimp a power connector pins (i.e., male end) to wires 1 and 2. Insert the crimped wires into the female end of the 2-pin Molex connector using the following pin layout. Note, the wires on the bulkhead connector are labeled with numbers and correspond to the numbering used below. 

<p align="center">
<img src="/hardware/images/IMG_0159.jpg" width="40%">
</p>

### Solder Micro-USB to Bulkhead Connector

### Remove Foam Backing and Cut Camera Tray

Remove the foam backing from the back plate of the Ikelite housing.

<p align="center">
<img src="/hardware/images/IMG_0144.jpg" width="40%"> <img src="/hardware/images/IMG_0152.jpg" width="40%">
</p>

Unscrew the camera tray from inside the Ikelite housing. Cut a 1-inch by 0.5-inch rectangle into the first two, thick plastic layers of the camera tray in the bottom, right corner. This creates an opening to allow the wires from the camera battery to be connected to the Molex connector from the bulkhead connector.

<p align="center">
<img src="/hardware/images/IMG_0154.jpg" width="40%"> <img src="/hardware/images/IMG_0155.jpg" width="40%">
</p>

## Modifications to Electronics

### Attach Molex Connector to the Camera's Internal Battery

### Solder Miniature Speaker to RPi

## Creating Cement Stand to Deploy Camera

## Author
Camille Pagniello (cpagniel@ucsd.edu)

Last Modification: 01/07/2020
