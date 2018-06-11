#!/bin/sh

#  shutdown_now.sh
#
#
#  Author: Camille Pagniello
#  Last Edit: 06/10/2018
#  Script to shutdown RPi

# ------------------------------------------------------------
# Setup Environment
# ------------------------------------------------------------

RUNFILE="run.log"

# ------------------------------------------------------------
# Check if FishOASIS.sh has timed out
# ------------------------------------------------------------

if [ $? -eq 124 ]; then

    echo ""
    echo "FishOASIS.sh has timed out"

    cd /media/DATA && echo "FishOASIS.sh has timed out at:" $(date) >> "${RUNFILE}"

# ------------------------------------------------------------
# Schedule next start-up
# ------------------------------------------------------------

    echo ""
    echo "Scheduling next start-up from shutdown_now.sh"

    cd /home/pi/wittyPi/schedules && sudo cp fishOASIS_12m.wpi /home/pi/wittyPi/schedule.wpi
    cd /home/pi/wittyPi && sudo ./runScript.sh

    echo "" && echo "RPi scheduled to turn back on in 12 minutes from shutdown_now.sh"
    cd /media/DATA && echo "RPi scheduled to turn back on in 12 minutes from shutdown_now.sh at:" $(date) >> "${RUNFILE}"

fi

# ------------------------------------------------------------
# Shutdown RPi
# ------------------------------------------------------------

echo ""
echo "RPi will shutdown in 10 seconds."

sleep 10

cd /media/DATA && echo "RPi shutdown at:" $(date) >> "${RUNFILE}"
cd /media/DATA && echo >> "${RUNFILE}"

sudo shutdown -h now
