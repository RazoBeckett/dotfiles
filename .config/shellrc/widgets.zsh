#!/usr/bin/env zsh

# Widget for tmux sessionizer
tmux_sessionizer_widget() { tmux-sessionizer }
zle -N tmux_sessionizer_widget
bindkey -M viins '^Bf' tmux_sessionizer_widget  # ctrl + f to open tmux sessionizer

# Widget for sesh
sesh_connect_widget() {
 sesh connect "$(sesh list -i | fzf --ansi --reverse --prompt=" " --pointer="" --ghost="Pick a sesh")"
}
zle -N sesh_connect_widget
bindkey -M viins '^B]' sesh_connect_widget      # ctrl + ] to connect to a tmux session
