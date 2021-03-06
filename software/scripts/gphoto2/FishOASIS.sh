#!/bin/bash

#  FishOASIS.sh
#
#
#  Author: Camille Pagniello
#  Last Edit: 07/05/2018
#  Script to schedule wittyPi and run timelapse.sh between 05:00 and 21:00
#
# ------------------------------------------------------------
# Setup Environment
# ------------------------------------------------------------

echo ""
echo "Current Time:" $(date)

start=$(date)
hour=$(date +%H)

# ------------------------------------------------------------
# Mount USB
# ------------------------------------------------------------

cd /home/pi/gphoto2
if [ -s usb_id.txt ]; then
    USBID=$(cat usb_id.txt)
    if [ $USBID = "FULL" ]; then
        cd /media/DATA
    else
        sudo mount /dev/$USBID /media/DATA -o uid=pi,gid=pi
        USBNAME=$(sudo blkid | grep $USBID | cut -b 19-23)
    fi
else
    sudo mount /dev/sda1 /media/DATA -o uid=pi,gid=pi
    USBID="sda1" && echo sda1 > usb_id.txt
    USBNAME=$(sudo blkid | grep $USBID | cut -b 19-23)
fi

# ------------------------------------------------------------
# Create .run file
# ------------------------------------------------------------

echo ""
echo "Create .run"

RUNFILE="run.log"

cd /media/DATA && echo "Start Time of FishOASIS.sh" $start >> "${RUNFILE}"

echo ""
cd /media/DATA && echo "Data stored to:" $USBNAME
cd /media/DATA && echo "Data stored to:" $USBNAME >> "${RUNFILE}"

# ------------------------------------------------------------
# Check current time
# ------------------------------------------------------------

if [ $hour -ge 5 ] && [ $hour -lt 21 ]; then

    echo ""
    echo "Current time is between 05:00 and 21:00"

# ------------------------------------------------------------
# Schedule next start-up
# ------------------------------------------------------------

    echo ""
    echo "Scheduling next start-up"

    cd /home/pi/wittyPi/schedules && sudo cp fishOASIS_12m.wpi /home/pi/wittyPi/schedule.wpi
    cd /home/pi/wittyPi && sudo ./runScript.sh

    echo "RPi scheduled to turn back on in 12 minutes from FishOASIS.sh"
    cd /media/DATA && echo "RPi scheduled to turn back on in 12 minutes from FishOASIS.sh at:" $(date) >> "${RUNFILE}"

# ------------------------------------------------------------
# Calibration
# ------------------------------------------------------------

    cd /media/DATA && echo "FishOASIS inter-calibration started at:" $(date) >> "${RUNFILE}"
    cd /home/pi/WiringPi/examples && sudo ./FishOASIS_calibration

# ------------------------------------------------------------
# Timelapse
# ------------------------------------------------------------

    cd /home/pi/gphoto2 && timeout 210s sudo ./timelapse.sh

    if [ $? -eq 124 ]; then

        echo ""
        echo "timelapse.sh has timed out"

        cd /media/DATA && echo "timelapse.sh has timed out at:" $(date) >> "${RUNFILE}"

    fi

# ------------------------------------------------------------
# If current time is not between 05:00 and 21:00
# ------------------------------------------------------------

else

    echo ""
    echo "Current time is not between 05:00 and 21:00"

# ------------------------------------------------------------
# Schedule next start-up
# ------------------------------------------------------------

    echo ""
    echo "Scheduling next start-up"

    cd /home/pi/wittyPi/schedules && sudo cp fishOASIS_5am_wakeup.wpi /home/pi/wittyPi/schedule.wpi
    cd /home/pi/wittyPi && sudo ./runScript.sh

    echo "RPi scheduled to turn back on tomorrow at 05:00 from FishOASIS.sh"
    cd /media/DATA && echo "RPi scheduled to turn back on tomorrow at 05:00 from FishOASIS.sh at:" $(date) >> "${RUNFILE}"

fi

# ------------------------------------------------------------
# Battery
# ------------------------------------------------------------

DEVICE=$(gphoto2 --auto-detect | grep usb | cut -b 36-42 | sed 's/,/\//')
if [ -z ${DEVICE} ]; then
    echo ""
    echo "Cannot read battery level because camera not detected."
else
    battery=$(gphoto2 --get-config='/main/status/batterylevel' | grep Current | cut -b 10-12)
    battery=$(gphoto2 --get-config='/main/status/batterylevel' | grep Current | cut -b 10-12)
    cd /media/DATA && echo "Battery level at" $(date +%T)":" $battery >> "${RUNFILE}"
fi

# ------------------------------------------------------------
# Temperature
# ------------------------------------------------------------

. /home/pi/wittyPi/utilities.sh

cd /home/pi/wittyPi && temp="$(get_temperature)"
cd /media/DATA && echo "wittyPi Temperature at" $(date +%T)":" $temp >> "${RUNFILE}"

# ------------------------------------------------------------
# Check USB space
# ------------------------------------------------------------

cd /home/pi/gphoto2 && sudo rm usb_space.txt
du -s /media/DATA | grep -o -E '[0-9]+' > /home/pi/gphoto2/usb_space.txt

cd /home/pi/gphoto2
if [ $(cat usb_space.txt) -ge 235929600 ]; then
    echo ""
    echo $USBNAME "is full"
    if [ $USBID = "sda1" ]; then
        sudo rm usb_id.txt && echo sdb1 > usb_id.txt
    elif [ $USBID = "sdb1" ]; then
        sudo rm usb_id.txt && echo sdc1 > usb_id.txt
    elif [ $USBID = "sdc1" ]; then
        sudo rm usb_id.txt && echo FULL > usb_id.txt
        cd /media && mkdir DATA
    fi
fi

# ------------------------------------------------------------
# Cleanup
# ------------------------------------------------------------

echo ""
echo "Cleaning up"

# Write .run
cd /media/DATA && echo "End Time of FishOASIS.sh" $(date) >> "${RUNFILE}"

# ------------------------------------------------------------
# Exit
# ------------------------------------------------------------

echo "Exit FishOASIS.sh "
echo ""
exit 0
