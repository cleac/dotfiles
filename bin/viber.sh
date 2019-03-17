#!/bin/bash
xrandr --output eDP-1 --scale .7x.7
flatpak run com.viber.Viber &
sleep 3
xrandr --output eDP-1 --scale 1x1
