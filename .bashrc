iatest=$(expr index "$-" i)
[ $iatest -gt 0 ] && bind "set bell-style visible" # Disable the bell
export HISTFILE="${XDG_STATE_HOME}"/bash/history
# Enable bash programmable completion features in interactive shells
[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion || { [[ -f /etc/bash_completion ]] && . /etc/bash_completion; }

[[ -f $HOME/.config/shellrc/exportrc ]] && source $HOME/.config/shellrc/exportrc       # Loads the $PATH Variable and Exports
[[ -f $HOME/.config/shellrc/nvigpurc ]] && source $HOME/.config/shellrc/nvigpurc       # Loads the $PATH Variable and Exports
[[ -f $HOME/.config/shellrc/aliasesrc ]] && source $HOME/.config/shellrc/aliasesrc     # Loads all aliases
[[ -f $HOME/.config/shellrc/fzftricksrc ]] && source $HOME/.config/shellrc/fzftricksrc # Loads all aliases
[[ -f $HOME/.config/shellrc/functionsrc ]] && source $HOME/.config/shellrc/functionsrc # Loads all custom functions
[[ -f $HOME/.config/shellrc/starshiprc ]] && source $HOME/.config/shellrc/starshiprc   # Loads startship config

set -o vi                            # vi mode
shopt -s autocd                      # Enable autocd (change directory just by typing its name)
eval "$(starship init bash)"         # Load starship prompt
pokemon-colorscripts --no-title -r 1 #,3,6 #toilet -f future -F gay "$(date +%d\ %m\ %Y)"
