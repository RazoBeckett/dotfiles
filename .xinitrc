#!/bin/env sh
xinitconfig() { nvim "$HOME/.xinitrc"; }

# XDG Paths
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_DIRS="/usr/local/share/:/usr/share"
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export PATH="$PATH:$HOME/.local/bin/statusbar"
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export GTK_THEME='Catppuccin-Macchiato-Standard-Teal-Dark:dark'
export XCURSOR_PATH=/usr/share/icons:"$XDG_DATA_HOME"/icons

# Environment variables set everywhere
unset EDITOR; unset TERMINAL; unset BROWSER
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="firefox-developer-edition"
export QT_QPA_PLATFORMTHEME="qt5ct"

exec dbus-launch --sh-syntax dwm # Start DWM
