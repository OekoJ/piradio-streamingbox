# Quelle: http://www.linuxforums.org/forum/applications/166700-all-i-want-simple-command-line-vu-meter.html
# folgende Zeile ist die Version in neuem Fenster
# xterm -sb -rightbar -fg yellow -bg black -e arecord -f cd -d 0 -vv /dev/null
# arecord -f cd -d 0 -vv /dev/null

# auch schoen in stereo
# http://phpforum.de/forum/showthread.php?t=279013
arecord -D plughw:1,0 /dev/null -V stereo -c 2 -f cd /dev/null
