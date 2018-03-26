# FishOASIS Software Installation Instructions

Installation instructions for software needed on Raspberry Pi A+ for FishOASIS.

## Install Packages

sudo apt-get update

### Git
sudo apt-get install git

### wittyPi
cd /home/pi
sudo wget http://www.uugear.com/repo/WittyPi2/installWittyPi.sh
sudo echo "Y N" | sh installWittyPi.sh

### gphoto2
cd /home/pi
wget https://raw.githubusercontent.com/gonzalo/gphoto2-updater/master/gphoto2-updater.sh
chmod +x gphoto2-updater.sh
sudo echo "2" | ./gphoto2-updater.sh

## Author
Camille Pagniello (cpagniel@ucsd.edu)

Last Edit: 03/25/2018
