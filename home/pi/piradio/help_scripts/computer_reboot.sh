#!/bin/bash

# use this script to reboot the computer
# For 24/7 running streaming this should be run by crontab every day. 
# To enable this run "crontab -e" and put the follow line (without the pefixed # ) in crontab:
#0 4 * * * sh /home/pi/piradio/help_scripts/computer_reboot.sh

sudo cp "/home/pi/piradio/logfiles/stream_output.txt" "/home/pi/piradio/logfiles/stream_output_$(date +%Y-%m-%d_%H:%M:%S).txt"
# sudo cp "../logfiles/stream_output.txt" "../logfiles/stream_output_$(date +%Y-%m-%d_%H:%M:%S).txt"

sudo rm /home/pi/piradio/logfiles/stream_output.txt
# sudo rm ../logfiles/stream_output.txt

sudo killall darkice 

sudo reboot
