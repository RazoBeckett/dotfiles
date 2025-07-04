#!/usr/bin/env zsh

# Widget for tmux sessionizer
tmux_sessionizer_widget() {
  zle push-input
  BUFFER=tmux-sessionizer
  zle accept-line
}
zle -N tmux_sessionizer_widget
bindkey -M viins '^Bf' tmux_sessionizer_widget  # ctrl + f to open tmux sessionizer

# Widget for sesh
sesh_connect_widget() {
  zle push-input
  BUFFER='sesh connect "$(sesh list -i | fzf --ansi --reverse --prompt=" " --pointer="" --ghost="Pick a sesh")"'
  zle accept-line
}
zle -N sesh_connect_widget
bindkey -M viins '^B]' sesh_connect_widget      # ctrl + ] to connect to a tmux session
