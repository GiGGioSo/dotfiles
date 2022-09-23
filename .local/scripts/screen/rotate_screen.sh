#!/bin/bash

declare -i NOTIFICATION_TIME
NOTIFICATION_TIME=1500

declare ROTATION
ROTATION=`xrandr --query --verbose | grep eDP-1 | sed 's/primary //' | awk '{print $5}'`

if [ $ROTATION = "normal" ]
then
    xrandr --output eDP-1 --rotate inverted
    notify-send -a 'Screen' 'Screen inverted' -r 3303 -i rotation-allowed-symbolic.symbolic -t $NOTIFICATION_TIME
elif [ $ROTATION = "inverted" ]
then
    xrandr --output eDP-1 --rotate normal
    notify-send -a 'Screen' 'Screen normal' -r 3303 -i rotation-allowed-symbolic.symbolic -t $NOTIFICATION_TIME
else
    xrandr --output eDP-1 --rotate normal
    notify-send -a 'Screen' 'Unsupported rotation: ${ROTATION}\nRestoring normal rotation' -r 3303 -i rotation-locked-symbolic.symbolic -t $NOTIFICATION_TIME
fi
