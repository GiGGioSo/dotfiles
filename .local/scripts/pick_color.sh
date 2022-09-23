#!/bin/sh

printf $(xcolor -P 192 -S 12) |  xclip -selection clipboard

notify-send -a 'ColorPicker' "Color: $(xclip -selection clipboard -o)" -h string:value:$volume -r 3301 -t 1500
