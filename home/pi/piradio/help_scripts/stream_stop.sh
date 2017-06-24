#!/bin/bash

# this script is to manually stop darkice 
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

	echo "################" >> ../logfiles/stream_output.txt
	echo "Stopped Darkice manually on $(date)" >> ../logfiles/stream_output.txt
	echo "################" >> ../logfiles/stream_output.txt

	echo "################"
	echo "Stopped Darkice manually on $(date)"
	echo "################"
else
	echo You must run this script as root! write 'sudo ./darkice_stop.sh'
fi
