#!/bin/bash

# aufgerufen von rc.local
# start scripts in /home/pi/piradio/run_on_boot/ 
# sh /home/pi/piradio/run_on_boot/run_all_this.sh

cd /home/pi/piradio/run_on_boot

#  schreibe die IP-Adresse
./write_ip.sh &

# starte das off-button py-skript
python off_button.py &
echo 'Off-Button scharf gestellt'

# destination=/media/usb0 # erster USB-Stick
# if [ -w $destination ] ; then # -w: writeable
#     ./usbstick_plugged.sh
# fi

# Gib das Mikro auf die Lautsprecherbuchse aus
# erlaubte Parameter pruefen mit: $ arecord -D dsnoop:1 --dump-hw-params
arecord -D dsnoop:1 -r 48000 -f S16_LE | aplay -D hw:0,0 &

# starte darkice
./start_stream.sh &
