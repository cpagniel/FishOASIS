# FishOASIS Software Installation Instructions
Installation instructions for software needed on Raspberry Pi A+ for FishOASIS.

Note: Before installing the packages below, please ensure that your microSD card has been properly formatted and you have completed the initial setup of the RPi. Instructions for formatting the microSD card and the initial setup of the RPi can be found [here](/software/FishOASIS_microSD_and_initial_setup.md).

## Install Packages
Additional packages have to be installed because the Raspbian OS Stretch Lite was used. Use the USB ethernet adapter to connect the RPi to the internet. 

First, check for updates of the current packages installed.
```
sudo apt-get update
```

### Git
Second, install Git. 
```
sudo echo "Y" | sudo apt-get install git
sudo reboot
```
Yes ("Y") will be selected when asked to install this package.

### wittyPi
Third, install the wittyPi package. The wittyPi should **NOT** be attached to the RPi during installation.
```
cd /home/pi
sudo wget http://www.uugear.com/repo/WittyPi2/installWittyPi.sh
sudo echo "Y N" | sudo sh installWittyPi.sh 
sudo reboot
```
Yes ("Y") will be selected when asked to remove fake-hwclock package and disable ntpd deamon. 
No ("N") will be selected when asked to install the QT5 option (i.e., wittyPi GUI).

After the wittyPi software is installed, shutdown the RPi using the command `sudo shutdown -h now`. Mount the wittyPi onto the RPi (while the RPi is off).

Test to ensure that the wittyPi package is installed and working by scheduling a shutdown and startup. Start the wittyPi.sh program using the following commands:
```
cd wittyPi
sudo ./wittyPi.sh
```
In the wittyPi.sh program, select `1. Write system time to RTC`. This will write the system time (set via the internet connection) to the RTC on the wittyPi. Next, select `6. Choose schedule script` and choose the pre-loaded script called `on_5m_every_20m`. The wittyPi will now turn on the RPi for 5 minutes every 20 minutes. Exit the wittyPi.sh program by selecting `8. Exit`.  

Shutdown the RPi using the command `sudo shutdown -h now` and wait for the wittyPi to turn on the RPi. Deselect the schedule script in the wittyPi.sh program before continuing with the installation of the next package.

### gphoto2
Fourth, install the gphoto2 package. Installing this package will take a long time (i.e., a few hours). Ensure that you have a secure internet connection. If the internet is disconnected at any point during the install, it will fail.  If the screen goes black, it has gone to sleep. This does not stop the install. Tap the space bar to wake it up, if desired. 
```
cd /home/pi
wget https://raw.githubusercontent.com/gonzalo/gphoto2-updater/master/gphoto2-updater.sh
chmod +x gphoto2-updater.sh
sudo echo "2" | sudo ./gphoto2-updater.sh
sudo reboot
```
To check if gphoto2 is installed, use the command:
```
gphoto2
```
This should thow an error, showing you a list of valid options.

### wiringPi
Finally, install the wiringPi package. The wiringPi project provides fine control over the GPIO pins from the command line and C. There are python and other wrappers for wiringPi as well. 
```
cd /home/pi
git clone git://git.dragon.net/wiringPi

cd wiringPi
./build
```

## Configure USB Mount Location

Create a directory to which a USB can be mounted to:
```
cd /media
sudo mkdir DATA
sudo chown -R pi:pi /media/DATA
```

Insert a USB stick and verify that it is identified by the system using `ls -l /dev/disk/by-uuid/`. USBs should be labeled sda1, sdb1, sdc1 etc.

Mount the USB using the command:
```
sudo mount /dev/sda1 /media/DATA -o uid=pi,gid=pi
```

Verify that the contents of the USB are visible using `cd /media/DATA && ls`.

To unmount the USB, use the command 
```
sudo umount /media/DATA
```

## Download the FishOASIS .sh Scripts

### gphoto2 .sh Scripts

Download the FishOASIS gphoto2 .sh scripts onto the RPi.
```
cd /home/pi && mkdir gphoto2
wget https://raw.githubusercontent.com/cpagniel/FishOASIS/master/software/scripts/gphoto2/FishOASIS.sh
chmod +x FishOASIS.sh
wget https://raw.githubusercontent.com/cpagniel/FishOASIS/master/software/scripts/gphoto2/shutdown_now.sh
chmod +x shutdown_now.sh
wget https://raw.githubusercontent.com/cpagniel/FishOASIS/master/software/scripts/gphoto2/timelapse.sh
chmod +x timelapse.sh
```

### wittyPi .wpi Schedule Scripts

Download the FishOASIS wittyPi .wpi schedule scripts onto the RPi and remove unnecessary schedule scripts.
```
cd /home/pi/wittyPi/schedules
rm *.wpi
wget https://raw.githubusercontent.com/cpagniel/FishOASIS/master/software/scripts/schedules/fishOASIS_5am_wakeup.sh
wget https://raw.githubusercontent.com/cpagniel/FishOASIS/master/software/scripts/gphoto2/fishOASIS_12m.sh
```

Start the wittyPi.sh program using the following commands:
```
cd wittyPi
sudo ./wittyPi.sh
```
In the wittyPi.sh program, select `6. Choose schedule script` and choose the script called `fishOASIS_12m.wpi`. The wittyPi will now turn on the RPi for 12 minutes until the RPi receives a shutdown command. Exit the wittyPi.sh program by selecting `8. Exit`.  

### wiringPi script

Download the FishOASIS calibration tone file onto the RPi.
```
cd /home/pi/wiringPi/examples
wget https://raw.githubusercontent.com/cpagniel/FishOASIS/master/software/scripts/wiringPi/FishOASIS_calibration.c
make FishOASIS_calibration
```

Test the calibration tone file using the command `sudo ./FishOASIS_calibration`.

## Edit .bashrc script

Add the following to the end of the .bashrc located in the `/home/pi` folder:
```
# Image Capture, wittyPi Scheduling and Shutdown Sequence for FishOASIS

sleep 10

cd /home/pi/wiringPi/examples
sudo ./FishOASIS_calibration

cd /home/pi/gphoto2
timeout 3000s sudo ./FishOASIS.sh
timeout 60s sudo ./shutdown_now.sh

# If all else fails, wittyPi will schedule and RPi will shutdown. (Code should never get here as RPi should already be turned off.)

echo “Scheduling next start-up from .bashrc”
cd /home/pi/wittyPi/schedules && sudo cp fishOASIS_12m.wpi /home/pi/wittyPi/schedule.wpi
cd /home/pi/wittyPi && sudo ./runScript.sh

RUNFILE=”run.log”
echo “RPi shutdown initiated from .bashrc in 10 seconds.”
cd /media/DATA && echo “RPi shutdown from the .bashrc at:” $(date) >> “${RUNFILE}”
cd /media/DATA && echo >> “${RUNFILE}”
sleep 10
sudo shutdown -h now
```
Reboot the RPI using the command `sudo reboot`.

**Congratulations, you have succesfully installed all of the software needed for FishOASIS onto the RPi!**

## Potential Errors

## timelapse.sh does not exist

If you get an error that says timelapse.sh does not exist, it is likely an issue with the document format. You’ll need to translate the timelapse.sh file to the correct format. Try the following fix from inside the gphoto2 folder:
```
tr –d “\015” < timelapse.sh > timelapse2.sh
chmod +x timelapse2.sh
sudo ./timelapse2.sh
```

If this runs the timelapse program, remove the old version and rename the new so it can be called by the .bashrc:
```
rm timelapse.sh
mv timelapse2.sh timelapse.sh
```

## Additional Information

For more details on the wittyPi, [click here](http://www.uugear.com/doc/WittyPi2_UserManual.pdf).

## Author
Camille Pagniello (cpagniel@ucsd.edu)

Last Modification: 06/10/2018
