#!/bin/bash
#
# Uebergabeparameter:
# "." kurz blinken: an-aus
# "-" lange blinken: an-aus
# "_" lange Pause: aus
# "1" nach Aktion LED anschalten: an

Port="10" # LED-Pin

# Port initialisieren; aber nur, wenn noch nicht erfolgt
if [ ! -f /sys/class/gpio/gpio${Port}/direction ] ; then
	if [ $USER != "root" ]; then
	  echo "Der erste Aufruf des Programms muss als root-User erfolgen!"
	  exit 1
	fi
	echo "Initialisiere GPIO $Port"
	echo "$Port" > /sys/class/gpio/unexport
	echo "$Port" > /sys/class/gpio/export
	echo "out" >/sys/class/gpio/gpio${Port}/direction
fi

## Make sure the script isn't already running 
## Fuehre das Programm nicht aus, wenn schon Instanz laeuft
################################################################################
# if [ `ps -e | grep -c $(basename $0)` -gt 2 ]; then echo $(basename $0) "laeuft schon"; exit 0; fi
################################################################################

# Check for the existence of a PID from the same script.
# and kill the previously started instances
# Quelle: http://unix.stackexchange.com/questions/213288/killing-the-previous-instances-of-a-script-before-running-the-same-unix-script

for pid in $(pidof -x $(basename $0)); do
    if [ $pid != $$ ]; then
        kill -9 $pid
	echo $pid " beendet"
    fi 
done


# erst mal kurz ausschalten
echo "0" > /sys/class/gpio/gpio${Port}/value
sleep 1

# Parameter uebernehmen
blinksignal=$1
laenge=${#blinksignal}
for ((i=0;i<laenge;i++));do
	einzelsignal=${blinksignal:$i:1}
	# echo $i: $einzelsignal
	case "$einzelsignal" in
	  ".")
		echo "1" > /sys/class/gpio/gpio${Port}/value
		sleep 0.15 ;;
	  "-") 
		echo "1" > /sys/class/gpio/gpio${Port}/value
		sleep 1 ;;
	  "_")
		echo "0" > /sys/class/gpio/gpio${Port}/value
		sleep 0.85 ;;
	esac
	echo "0" > /sys/class/gpio/gpio${Port}/value
	sleep 0.15
done

# wieder anschalten, wenn letzte Eintrag "1"
if [ $einzelsignal == "1" ]; then
	echo "1" > /sys/class/gpio/gpio${Port}/value
fi

