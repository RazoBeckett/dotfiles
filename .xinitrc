#!/bin/sh
xset r rate 210 40    #speedy keys

# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# Environment variables set everywhere
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"

# running scripts
[ -f $HOME/.xinit/touchpad.sh ]	&& $HOME/.xinit/touchpad.sh &                       # enable tap to click & natural scrolling
[ -f $HOME/.xinit/pipewire-launcher.sh ] && $HOME/.xinit/pipewire-launcher.sh &     # initial pipewire audio
[ -x /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ] && exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

touchegg &
# Misc.
nitrogen --restore &              # sets wallpaper
setxkbmap -option caps:escape     # now caps works like esc 
# Start DWM
exec dbus-launch --sh-syntax dwm
