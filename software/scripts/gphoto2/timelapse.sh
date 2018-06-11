#!/bin/sh

#  timelapse.sh
#
#
#  Author: Camille Pagniello
#  Last Edit: 02/21/2018
#  Script for camera timelapse
#
# ------------------------------------------------------------
# Setup Environment
# ------------------------------------------------------------

echo ""
echo "Start timelapse.sh"
echo ""

start_sh=$(date)

# ------------------------------------------------------------
# Write to .run file
# ------------------------------------------------------------

RUNFILE="run.log"

cd /media/DATA && echo "Start Time of timelapse.sh" $start_sh >> "${RUNFILE}"

# ------------------------------------------------------------
# Create folder
# ------------------------------------------------------------

folder=$(date +%Y%m%d)
cd /media/DATA && mkdir -p "$folder"
cd /media/DATA/"$folder"

# ------------------------------------------------------------
# Wait for camera to be turned on by checking USB
# ------------------------------------------------------------

DEVICE=$(gphoto2 --auto-detect | grep usb | cut -b 36-42 | sed 's/,/\//')
kill_sh=$(date --date='2 minute' +%s)

while [ -z ${DEVICE} ]; do

    echo "Camera not detected" &&  echo "Check again in 1 minute"
    cd /media/DATA && echo "No camera detected:" $(date +%F_%T) >> "${RUNFILE}"

    sleep 1m

    DEVICE=$(gphoto2 --auto-detect | grep usb | cut -b 36-42 | sed 's/,/\//')
    cd /media/DATA && echo "Checked for camera again:" $(date +%F_%T) >> "${RUNFILE}"

    clck_sh=$(( $(date +%s) - $kill_sh ))
    if [ $clck_sh -ge 0 ] && [ -z ${DEVICE} ]; then
        echo "Camera not detected for 2 minutes" && echo ""
        echo "Exit timelapse.sh" && echo ""
        cd /media/DATA && echo "Camera not detected for 2 minutes. Current time:" $(date +%F_%T) >> "${RUNFILE}"
        cd /media/DATA && echo "End Time of timelapse.sh" $(date) >> "${RUNFILE}"
        exit 0
    fi

done

# ------------------------------------------------------------
# Initialize camera
# ------------------------------------------------------------

echo "Camera detected"
cd /media/DATA && echo "Camera detected:" $(date +%F_%T) >> "${RUNFILE}"

gphoto2 --auto-detect --summary >/dev/null

battery=$(gphoto2 --get-config='/main/status/batterylevel' | grep Current | cut -b 10-12)
battery=$(gphoto2 --get-config='/main/status/batterylevel' | grep Current | cut -b 10-12)
echo "Battery level is" $battery
cd /media/DATA && echo "Battery level at" $(date +%T)":" $battery >> "${RUNFILE}"

# ------------------------------------------------------------
# Starting image capture...
# ------------------------------------------------------------

cd /media/DATA && echo "Start Time of image capture:" $(date) >> "${RUNFILE}"

# ------------------------------------------------------------
# Image capture
# ------------------------------------------------------------

cnt=1
while [ $cnt -le 2 ]; do

    echo ""
    echo "Capturing images"

    cd /media/DATA/"$folder"
    timeout 80s gphoto2 --capture-image-and-download \
    --interval=5 \
    --frames=12 \
    --filename="%y%m%d_%H%M%S.arw" \
    --force-overwrite \
    --keep \
    --quiet

    if [ $? -eq 124 ]; then
        echo "gphoto2 has timed out"

        cd /media/DATA && echo "gphoto2 has timed out at:" $(date) "on cycle" $cnt >> "${RUNFILE}"
    fi

    if [ $cnt -lt 2 ]; then
        echo "Sleeping for 30 seconds"
        sleep 30
    fi

    cnt=$(( $cnt + 1 ))

done

# ------------------------------------------------------------
# Ending image capture...
# ------------------------------------------------------------

cd /media/DATA && echo "End Time of image capture:" $(date) >> "${RUNFILE}"

# ------------------------------------------------------------
# Cleanup
# ------------------------------------------------------------

echo ""
echo "Cleaning up"

cd /media/DATA && echo "End Time of timelapse.sh" $(date) >> "${RUNFILE}"

# ------------------------------------------------------------
# Exit
# ------------------------------------------------------------

echo ""
echo "Exit timelapse.sh"
echo ""
exit 0
