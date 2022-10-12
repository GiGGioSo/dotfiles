#!/bin/bash

declare -i ID
ID=`xinput list | grep -Eio '(touchpad|glidepoint)\s*id\=[0-9]{1,2}' | grep -Eo '[0-9]{1,2}' | head -n 1`
declare -i STATE
STATE=`xinput list-props $ID | grep 'Device Enabled' | awk '{print $4}'`
echo $ID

case $1 in
    on)
    if [ $STATE -eq 0 ]
    then
        xinput enable $ID
        # echo "Touchpad enabled."
        notify-send -a 'Touchpad' 'Touchpad enabled' -r 3302 -i touchpad-disabled-symbolic.symbolic -t 800
    fi
	;;
    off)
    if [ $STATE -eq 1 ]
    then
        xinput disable $ID
        # echo "Touchpad disabled."
        notify-send -a 'Touchpad' 'Touchpad disabled' -r 3302 -i touchpad-disabled-symbolic.symbolic -t 800
    fi
	;;
    toggle)
    if [ $STATE -eq 1 ]
    then
        xinput disable $ID
        # echo "Touchpad disabled."
        notify-send -a 'Touchpad' 'Touchpad disabled' -r 3302 -i touchpad-disabled-symbolic.symbolic -t 800
    else
        xinput enable $ID
        # echo "Touchpad enabled."
        notify-send -a 'Touchpad' 'Touchpad enabled' -r 3302 -i touchpad-disabled-symbolic.symbolic -t 800
    fi
    ;;
esac

