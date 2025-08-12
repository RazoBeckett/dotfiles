#!/bin/bash
brightness=$(brightnessctl | grep -oP '\(\K[0-9]+')
printf " %02d\n" "$brightness"
