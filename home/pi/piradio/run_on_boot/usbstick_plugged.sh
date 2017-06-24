#!/bin/bash
# This script is called from /etc/usbmount/mount.d/50_usbstick_plugged
# usge: usbstick_plugged.sh [MOUNTPOINT]
# If a USB storage is plugged in, this script copies the recorded audio to the USB storage
# and unmounts the USB storage if finished 
# Quelle: https://www.raspberrypi.org/forums/viewtopic.php?f=63&t=125495#

## Make sure the script isn't already running from a previous disk connection
################################################################################
if [ `ps -e | grep -c $(basename $0)` -gt 2 ]; then exit 0; fi
################################################################################
#
sleeptime=5
logfile=/home/pi/piradio/logfiles/usbstick.log
destination=/media/usb0 # wenn kein Parameter uebergeben wird, nimm den ersten USB-Stick
# source=/home/pi/piradio/recordings/recording.ogg # wird jetzt aus dem confif-file gezogen
darkice_config=/home/pi/piradio/stream_config/stream_configuration.cfg # Quelle fuer recording-file

function recfilename {
	shopt -s extglob
	while IFS='= ' read lhs rhs
	do
	    if [[ ! $lhs =~ ^\ *# && -n $lhs ]]; then
		rhs="${rhs%%\#*}"    # Del in line right comments
		rhs="${rhs%%*( )}"   # Del trailing spaces
		rhs="${rhs%\"*}"     # Del opening string quotes 
		rhs="${rhs#\"*}"     # Del closing string quotes 
		# echo $lhs="$rhs"
		# declare $lhs="$rhs"
		if [ $lhs == localDumpFile ]; then 
			declare $lhs="$rhs"
		fi
	    fi
	done < $darkice_config
	echo $localDumpFile
}

source=$(recfilename)

MaxTries=20
cmd_signal_ready="/home/pi/piradio/run_on_boot/blinki.sh ---_ &"
cmd_signal_error="/home/pi/piradio/run_on_boot/blinki.sh ........1"
cmd_signal_OK="/home/pi/piradio/run_on_boot/blinki.sh ---_-.-_1 &"
cmd_update_configfiles_from_usb="/home/pi/piradio/run_on_boot/update_configfiles_from_usb.sh"

function addTimestampToFilename {
    # this function adds a timestamp to a filename which is passed together with its path
    # returns only filename (without path)
    filenameWithPath=$1;
    datestring=$(stat --printf='%y' $filenameWithPath) # get the modification date of file
    datestring=${datestring%.*} # cut it after "."
    datestring=${datestring// /_}  # replace all (//) Spaces by "_"
    datestring=${datestring//:/.}  # replace all (//) ":" by "."
    # datestring=$(echo "$datestring" | tr ' ' '_') # replace Space by "_"
    # datestring=$(echo "$datestring" | tr ':' '.') # replace : by "."
    echo $datestring\_${filenameWithPath##*/}
}

if [ ! -z "$1" ]; then
    let destination=$1 # $1 ist der Mountpoint, der aus dem Trigger-Skript uebergeben wird
fi


echo "Script Started" | tee -a ${logfile}
date >> $logfile
# Test if the Destination disk is connected.
ActualTry=1
until [ $ActualTry -gt $MaxTries ]
do
 echo "Versuch: $ActualTry/$MaxTries" | tee -a ${logfile}
 if [ -w $destination ] # -w: writeable
 then
    mountpoint=$(df --output=source $destination | tail -n +2)
    $cmd_signal_ready
    destinationfile=$(addTimestampToFilename $source)
    echo "USB Storage unter $mountpoint gefunden" | tee -a ${logfile}
    # hostname -I > $destination/ip_address_$(date +%Y.%m.%d_%H-%M-%S).txt
    hostname -I > $destination/ip_address.txt
    echo "IP-Adresse auf USB Storage geschrieben" | tee -a ${logfile}
    # NEU! Kopiere (darkice) Configfile vom USB Storage auf lokal
    $cmd_update_configfiles_from_usb $destination # | tee -a ${logfile}
    if [[ $? -eq 0 ]] ; then
	# ja, es war ein neueres Configfile auf dem USB Storage, also breche das Skript hier ab 
	echo "Unmount the USB storage $mountpoint" | tee -a ${logfile}
	sudo umount $destination >> $logfile 2>&1
	echo "Script Complete" | tee -a ${logfile}
	echo "===============" | tee -a ${logfile}   
	echo | tee -a ${logfile}
	echo | tee -a ${logfile}
	echo | tee -a ${logfile}
	exit 0
    fi
    echo "== Copying of $destinationfile started ==" | tee -a ${logfile}
    cp $source $destination/$destinationfile >> $logfile 2>&1
    # rsync -avzh $source $destination/$destinationfile >> $logfile 2>&1 # rsync klappt nicht, weil sich Datei sich noch aendert, solange Darkice laeuft
    echo "Kopieren der Datei $destinationfile abgeschlossen" | tee -a ${logfile}
    echo "Unmount the USB storage $mountpoint" | tee -a ${logfile}
    sudo umount $destination >> $logfile 2>&1

    date >> $logfile
    echo "== Copy Complete ==" | tee -a ${logfile}
    let ActualTry=$MaxTries
 else
    echo "== USB Storage nicht gefunden ==" | tee -a ${logfile}
    $cmd_signal_error
    sleep $sleeptime
 fi
 let ActualTry++
done
echo "Script Complete" | tee -a ${logfile}
echo "===============" | tee -a ${logfile}   
echo | tee -a ${logfile}
echo | tee -a ${logfile}
echo | tee -a ${logfile}
$cmd_signal_OK

