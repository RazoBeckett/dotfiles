#!/bin/env sh
xset r rate 210 40    #speedy keys

# XDG Paths
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share/:/usr/share"
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export XCURSOR_PATH=/usr/share/icons:"$XDG_DATA_HOME"/icons

# Environment variables set everywhere
unset EDITOR; unset TERMINAL; unset BROWSER
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"
export QT_QPA_PLATFORMTHEME="qt5ct"

# running scripts
#[ -f $HOME/.config/xinit/touchpad.sh ]	&& $HOME/.config/xinit/touchpad.sh &                          # enable tap to click & natural scrolling
[ -f "$HOME/.config/xinit/pipewire-launcher.sh" ] && "$HOME/.config/xinit/pipewire-launcher.sh" &     # initial pipewire audio
[ -x /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 ] && exec /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Misc.
# setxkbmap -option caps:escape         # now caps works like esc , setup in here: /usr/share/X11/xkb/symbols/pc
xrdb -load "$HOME/.config/Xresources"   # loads Xresources
# Start DWM
exec dbus-launch --sh-syntax dwm
