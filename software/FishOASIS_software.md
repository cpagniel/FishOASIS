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
Fourth, install gphoto2 package. Installing this package will take a long time (i.e., a few hours). Ensure that you have a secure internet connection. If the internet is disconnected at any point during the install, it will fail.  If the screen goes black, it has gone to sleep. This does not stop the install. Tap the space bar to wake it up, if desired. 
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



### 

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
