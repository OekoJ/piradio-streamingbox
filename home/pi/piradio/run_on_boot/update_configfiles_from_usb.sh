#!/bin/bash
# Parameter $1 is the USB-Drive e.g. /media/usb0

logfile="/home/pi/piradio/logfiles/usbstick.log"
darkice_config="/home/pi/piradio/stream_config/stream_configuration.cfg"
cmd_darkice_restart="/home/pi/piradio/help_scripts/stream_restart.sh"
wlan_config="/etc/wpa_supplicant/wpa_supplicant.conf"
# wlan_config="/home/pi/piradio/help_scripts/wlan-setup.conf"
cmd_wlan_restart="/home/pi/piradio/help_scripts/wifi_reconnect.sh"
usbdrive=$1
exitstatus=1

function copyIfDifferent {
    # kopiere nur, wenn Unterschiede
    fileToCopy=$1
    if $(cmp --silent $usbdrive/${fileToCopy##*/} $fileToCopy); then
	# keine Unterschiede gefunden
	# 1 = false
	return 1
    else
	renamedfile=$(addTimestampToFilename $fileToCopy) # packe timestamp davor
	mv $fileToCopy ${fileToCopy%/*}/$renamedfile # nenne lokales configfile um
	sudo cp $usbdrive/${fileToCopy##*/} $fileToCopy # ${fileToCopy%/*}/ # kopiere von usb nach lokal
	sudo chown pi $fileToCopy # aendere den eigentuemer auf pi
	echo "== ${fileToCopy##*/} von USB auf lokal kopiert ==" | tee -a ${logfile}
	# 0 = true
	return 0 
    fi
}

function addTimestampToFilename {
    # this function adds a timestamp to a filename which is passed together with its path
    # returns only filename (without path)
    filenameWithPath=$1;
    datestring=$(stat --printf='%y' $filenameWithPath) # get the modification date of file
    datestring=${datestring%.*} # cut it after "."
    datestring=${datestring// /_}  # replace all (//) Spaces by "_"
    datestring=${datestring//:/.}  # replace all (//) ":" by "."
    echo $datestring\_${filenameWithPath##*/} # dieser Wert wird an Aufrufer zurueck gegeben
}  

if [ -w $usbdrive ]; then # -w: writeable --> USB Storage is mounted
	# Checke Darkice Configfile 
	if [ -f $usbdrive/${darkice_config##*/} ]; then # Config File exists on USB Storage
		# copysuccess=$(copyIfDifferent $darkice_config)
		if copyIfDifferent $darkice_config; then 
			sudo $cmd_darkice_restart >/dev/null & 
			echo "--> Darkice neu gestartet" | tee -a ${logfile}
			let exitstatus=0			
		else
			echo "-- Darkice Configfile gefunden, aber nicht kopiert, weil Datei ${darkice_config##*/} identisch --" | tee -a ${logfile}
		fi
	else
		echo "-- kein Darkice Configfile auf dem USB Storage gefunden --" | tee -a ${logfile}
	fi
	# Checke WLAN Configfile 
	if [ -f $usbdrive/${wlan_config##*/} ]; then # WLAN-Config File exists on USB Storage
		if copyIfDifferent $wlan_config; then 
			sudo $cmd_wlan_restart >/dev/null & 
			echo "--> WLAN neu gestartet" | tee -a ${logfile}
			let exitstatus=0			
		else
			echo "-- WLAN Configfile gefunden, aber nicht kopiert, weil Datei ${darkice_config##*/} identisch --" | tee -a ${logfile}
		fi
	else
		echo "-- kein WLAN Configfile auf dem USB Storage gefunden --" | tee -a ${logfile}
	fi
 else
    echo "== USB Storage nicht gefunden ==" | tee -a ${logfile}
 fi
exit $exitstatus
