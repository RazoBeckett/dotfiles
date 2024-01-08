#!/bin/sh
xset r rate 210 40    #speedy keys

# XDG Paths
export XDG_CONFIG_HOME=$HOME/.config/
export XDG_CACHE_HOME=$HOME/.cache/
export XDG_DATA_HOME=$HOME/.local/share/
export XDG_STATE_HOME=$HOME/.local/state
export XDG_DATA_DIRS=/usr/local/share/:/usr/share

# Environment variables set everywhere
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"
export QT_QPA_PLATFORMTHEME="qt5ct"

# running scripts
#[ -f $HOME/.config/xinit/touchpad.sh ]	&& $HOME/.config/xinit/touchpad.sh &                       # enable tap to click & natural scrolling
[ -f $HOME/.config/xinit/pipewire-launcher.sh ] && $HOME/.config/xinit/pipewire-launcher.sh &     # initial pipewire audio
[ -x /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ] && exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Misc.
setxkbmap -option caps:escape     # now caps works like esc 
# Start DWM
exec dbus-launch --sh-syntax dwm
