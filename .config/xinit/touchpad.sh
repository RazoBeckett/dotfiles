#!/bin/bash

# Find the touchpad device ID
device_id=$(xinput list | grep "Touchpad" | grep -o 'id=[0-9]*' | sed 's/id=//')

if [ -z "$device_id" ]; then
  dunstify "HARDWARE_ERROR:" "Touchpad_not_found."
  exit 1
fi

# Enable tap-to-click
xinput set-prop "$device_id" "libinput Tapping Enabled" 1
# Enable Natural Scroll
xinput set-prop "$device_id" "libinput Natural Scrolling Enabled" 1
#echo "Touchpad is ready with Tap-To-Click and Natural Scroll $device_id"
#dunstify "Touchpad is ready with Tap-To-Click and Natural Scroll $device_id"
