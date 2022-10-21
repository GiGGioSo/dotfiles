#!/bin/bash

# compositor
picom --experimental-backends &

# automatic backlight based on ambient light
clight &

# screen locket
xss-lock -- i3lock &


# << Not in use >>

# wal -qR &
