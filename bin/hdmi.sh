#!/bin/bash

case $1 in
  'left')
    xrandr --output HDMI-2 --auto --left-of eDP-1;;
  'right')
    xrandr --output HDMI-2 --auto --right-of eDP-1;;
  'top')
    xrandr --output HDMI-2 --auto --above eDP-1;;
  'off')
    xrandr --output HDMI-2 --off;;
  *)
    echo -e 'Usage:\n hdmi.sh (left|right|top|off)'
esac

