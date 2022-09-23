#!/bin/sh

function send_notification {

    volume="$(amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1)"
    mute="$(amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off)"

    if [ $volume -eq "0" ] || [ ! -z "$mute" ]; then
        notify-send -a 'Volume' "Volume: $volume%" -h int:value:$volume -r 3301 -i audio-volume-muted-symbolic.symbolic -t 1200
    elif [ $volume -lt "51" ]; then
        notify-send -a 'Volume' "Volume: $volume%" -h int:value:$volume -r 3301 -i audio-volume-low-symbolic.symbolic -t 1200
    else
        notify-send -a 'Volume' "Volume: $volume%" -h int:value:$volume -r 3301 -i audio-volume-high-symbolic.symbolic -t 1200
    fi

}

case $1 in
    up)
	amixer -q sset Master 5%+
    send_notification
	;;
    down)
	amixer -q sset Master 5%-
    send_notification
	;;
    mute)
	amixer -q set Master toggle
    send_notification
    ;;
esac
