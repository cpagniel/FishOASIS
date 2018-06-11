#!/bin/bash

#  FishOASIS.sh
#
#
#  Author: Camille Pagniello
#  Last Edit: 06/10/2018
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

sudo mount /dev/sda1 /media/DATA -o uid=pi,gid=pi
USBID=$(df | grep /dev/sd | cut -b 6-9)
USBNAME=$(sudo blkid | grep $USBID | cut -b 19-23)

# ------------------------------------------------------------
# Check USB space
# ------------------------------------------------------------

cd /media
SPACE=$(du | grep [0-9] | tail -1)
if [ $SPACE -ge 235929600 ]; then
    echo ""
    echo $USBNAME "is full"
    sudo umount /media/DATA

    sudo mount /dev/sdb1 /media/DATA -o uid=pi,gid=pi
    USBID=$(df | grep /dev/sd | cut -b 6-9)
    USBNAME=$(sudo blkid | grep $USBID | cut -b 19-23)

    cd /media
    SPACE=$(du | grep [0-9] | tail -1)
    if [ $SPACE -ge 235929600 ]; then
        echo ""
        echo $USBNAME "is full"
        sudo umount /media/DATA

        sudo mount /dev/sdc1 /media/DATA -o uid=pi,gid=pi
        USBID=$(df | grep /dev/sd | cut -b 6-9)
        USBNAME=$(sudo blkid | grep $USBID | cut -b 19-23)

        cd /media
        SPACE=$(du | grep [0-9] | tail -1)
        if [ $SPACE -ge 235929600 ]; then
            echo ""
            echo $USBNAME "is full"
            sudo umount /media/DATA

            cd /media
            mkdir DATA
        fi
    fi
fi

# ------------------------------------------------------------
# Create .run file
# ------------------------------------------------------------

echo ""
echo "Create .run"

RUNFILE="run.log"

cd /media/DATA && echo "Start Time of FishOASIS.sh" $start >> "${RUNFILE}"

echo ""
echo "Data stored to:" $USBNAME && echo "Used space on USB:" $SPACE
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
