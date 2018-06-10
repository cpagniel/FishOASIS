# FishOASIS microSD Card Formatting Instructions and Initial Raspberry Pi A+ Setup
Formatting instructions for microSD card as well as configuration of initial settings of the Raspberry Pi A+.

## Format microSD Card using SD Card Formatter
A microSD card adapter will be needed to read the microSD card. 

### Using Windows
Format the microSD card in FAT32 using SD Card Formatter.  
<img src="/software/images/SD_Card_Formatter_Windows1.png" width="40%"> 

In Option, Select "Full (Erase)" for Format Type and turn "ON" Format Size Adjustment.  
<img src="/software/images/SD_Card_Formatter_Windows2.png" width="20%">

### Using Mac
Erase the contents on the microSD card using SD Card Formatter. Use Quick Format to ensure all the disk space is available.
<img src="/software/images/SD_Card_Formatter_Mac.png" width="40%">

Use Disk Utility to format the microSD card in MS-DOS (FAT32) or MS-DOS(FAT).
<img src="/software/images/Disk_Utility.png" width="40%">

## Flash Raspbian Stretch Lite Image

Use Etcher to flash the Raspbian Stretch Lite image onto the microSD card. Etcher is used on both Windows and Mac OS. Typically, flashing takes 5 to 10 minutes on a Windows computer or 2 minutes on a Mac computer. The microSD card will no longer be listed after flashing and does not need to be safely ejected from the computer.

<img src="/software/images/Etcher.png" width="40%">

## Downloads

[Click here](https://www.sdcard.org/downloads/formatter_4/) to download SD Card Formatter.  
[Click here](https://etcher.io/) to download Etcher. 
[Click here](https://www.raspberrypi.org/downloads/raspbian/) to download Raspbian Stretch Lite Image. 

## Author
Camille Pagniello (cpagniel@ucsd.edu)

Last Modification: 06/10/2018
