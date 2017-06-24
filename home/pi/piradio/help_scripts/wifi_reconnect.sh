#!/bin/bash

# use this script to check network availability and reconnect to wlan0 if not connected 
# this can be run by crontab every minute. 
# To enable this run "crontab -e" and put the follow line (without the pefixed # ) in crontab:
#* * * * * sh /home/pi/piradio/help_scripts/wifi_reconnect.sh

logfile="/home/pi/piradio/logfiles/wifi_reconnect_log.txt"
cmd_writeIP="/home/pi/piradio/run_on_boot/write_ip.sh"
urlToTest="piradio.de"

if fping $urlToTest | grep alive; then
	echo Everything is fine. Wifi is up. $(date) >> $logfile
	exit
else
	sudo ifdown --force wlan0
	sudo ifup wlan0
	sleep 10
	sudo killall darkice
	sh $cmd_writeIP
	echo "Reconnected wifi and stopped Darkice on $(date)" >> $logfile
fi
