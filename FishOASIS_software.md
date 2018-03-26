# FishOASIS Software Installation Instructions
Installation instructions for software needed on Raspberry Pi A+ for FishOASIS.

## Install Packages
Additional packages have to be installed because the Raspbian OS Stretch Lite was used. Use the USB ethernet adapter to connect the RPi to the internet. 

First, check for updates of the current packages installed.
```
sudo apt-get update
```

### Git
Second, install Git. When asked, choose yes ("Y") to install this package.
```
sudo apt-get install git
sudo reboot
```

### wittyPi
Third, install wittyPi package. The wittyPi should **NOT** be attached to the RPi during installation.
```
cd /home/pi
sudo wget http://www.uugear.com/repo/WittyPi2/installWittyPi.sh
sudo echo "Y N" | sh installWittyPi.sh
sudo reboot
```
When asked to remove fake-hwclock package and disable ntpd deamon, choose yes ("Y"). 
When asked to install the QT5 option (i.e., wittyPi GUI), choose no ("N").

For more details on the wittyPi, [click here](http://www.uugear.com/doc/WittyPi2_UserManual.pdf).

After the wittyPi software is installed, shutdown the RPi using the command `sudo shutdown -h now`. Mount the wittyPi onto the RPi (while the RPi is off).

Test 

### gphoto2
```
cd /home/pi
wget https://raw.githubusercontent.com/gonzalo/gphoto2-updater/master/gphoto2-updater.sh
chmod +x gphoto2-updater.sh
sudo echo "2" | ./gphoto2-updater.sh
```

## Author
Camille Pagniello (cpagniel@ucsd.edu)

Last Modification: 03/25/2018
