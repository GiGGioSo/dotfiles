#!/bin/bash

# compositor
picom --experimental-backends &


# screen locket
xss-lock -- i3lock -i "$HOME/.config/wallpapers/colorful-mountain.png" &

### Not in use ###

# wal -qR &

# automatic backlight based on ambient light and system tray icon for manual setting
# clight &
# clight-gui --tray &
