#!/bin/bash
logfile="/home/pi/piradio/logfiles/stream_output.txt"
darkice_config="/home/pi/piradio/stream_config/stream_configuration.cfg"
darkiceRebootSwitch="/home/pi/piradio/stream_config/darkice_reboot.cfg"

echo started script on $(date) >> $logfile
echo 

cmd_signal_ready="/home/pi/piradio/run_on_boot/blinki.sh ..._1 "
cmd_signal_OK="/home/pi/piradio/run_on_boot/blinki.sh ---_-.-_1 &"
cmd_signal_error="/home/pi/piradio/run_on_boot/blinki.sh ........ &"
cmd_rename_recording="/home/pi/piradio/run_on_boot/rename_recording.sh"

## Make sure the script isn't already running 
################################################################################
if [ `ps -e | grep -c $(basename $0)` -gt 2 ]; then echo $(basename $0) is already running, stopping script; exit 0; fi
################################################################################

running=true

# show that skript has started
$cmd_signal_ready

if pgrep darkice; then
    echo ########
    echo another instance of darkice found, stopping script.
    echo ########
    #running=false

else
    echo no instance of darkice running.
    echo reconnect script initialised, running loop.
    lastSeconds=0
    currentSeconds=0
    failedTries=0
fi

while [ $running = true ]; do
        date >> $logfile
        echo >> $logfile
	lastseconds=$(date +%s)
	$cmd_rename_recording # move the old recording because Darkice will overwrite it on start 
        echo Versuche Darkice zu starten...
	# show that connection was successful
	$cmd_signal_OK
        sudo darkice -c $darkice_config | tee -a ${logfile}
	if [ $(($(date +%s)-$lastseconds)) -lt 20 ]; then
            if grep ON $darkiceRebootSwitch; then    
		failedTries="$((failedTries+1))"
		echo Darkice failed, under 60 secs. It has failed $failedTries times, will reboot at 5 failed tries. | tee -a ${logfile}
	    fi
        else
            failedTries=0
        fi
        if [ $failedTries -gt 5 ]; then
	    sudo reboot
        fi
        echo darkice crashed, retrying in 10 seconds. | tee -a ${logfile}
	$cmd_signal_error
	sleep 10
done
