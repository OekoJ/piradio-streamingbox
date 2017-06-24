#!/bin/bash

# this script is to manually restart darkice 
if [ $(whoami) = 'root' ]; then
	sudo killall darkice
	# stoppe das start_stream.sh-Skript
	# dies killt nur eine einzelne Instanz
	# sudo kill $(ps -x | grep start_stream.sh | awk '{print $1}')

	# Check for the existence of a PID from start_stream.sh-script.
	# and kill all instances
	for pid in $(pidof -x start_stream.sh); do
	   sudo kill -9 $pid
	   echo $pid " beendet"
	done
	# Kurzform:
	# for pid in $(pidof -x start_stream.sh); do sudo kill -9 $pid; echo $pid " beendet"; done


	echo "################" >> ../logfiles/stream_output.txt
	echo "Stopped Darkice manually on $(date)" >> ../logfiles/stream_output.txt
	echo "################" >> ../logfiles/stream_output.txt

	echo "################"
	echo "Stopped Darkice manually on $(date)"
	echo "################"

	/home/pi/piradio/run_on_boot/start_stream.sh &
	# das start_stream.sh skript startet den Darkice-Server alle 10 Sekunden von alleine
	# sudo darkice -c ../stream_config/stream_configuration.cfg >> ../logfiles/stream_output.txt &
	# echo Darkice neu gestartet
else
	echo You must start this script as root! write 'sudo ./darkice_restart.sh'
fi
