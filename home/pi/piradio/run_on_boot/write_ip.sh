#!/bin/bash

hostname -I > /home/pi/piradio/ip_address.txt
ifconfig > /home/pi/piradio/logfiles/ip_full_output.txt
iwgetid -r >> /home/pi/piradio/logfiles/ip_full_output.txt

hostname -I
ifconfig
iwgetid
