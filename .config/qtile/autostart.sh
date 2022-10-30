#!/bin/bash

# compositor
picom --experimental-backends &

# automatic backlight based on ambient light
clight &

# screen locket
xss-lock -- i3lock -i "$HOME/.config/wallpapers/colorful-mountain.png" &


# << Not in use >>

# wal -qR &
