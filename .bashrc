iatest=$(expr index "$-" i)
[ $iatest -gt 0 ] && bind "set bell-style visible"					# Disable the bell

# Enable bash programmable completion features in interactive shells
[[ -f /usr/share/bash-completion/bash_completion ]] && . /usr/share/bash-completion/bash_completion || { [[ -f /etc/bash_completion ]] && . /etc/bash_completion; }

[[ -f $HOME/.shell/exportrc ]] && source $HOME/.shell/exportrc			      # Loads the $PATH Variable and Exports
[[ -f $HOME/.shell/nvigpurc ]] && source $HOME/.shell/nvigpurc			      # Loads the $PATH Variable and Exports
[[ -f $HOME/.shell/aliasesrc ]] && source $HOME/.shell/aliasesrc			    # Loads all aliases
[[ -f $HOME/.shell/fzftricksrc ]] && source $HOME/.shell/fzftricksrc			# Loads all aliases
[[ -f $HOME/.shell/functionsrc ]] && source $HOME/.shell/functionsrc		  # Loads all custom functions 
[[ -f $HOME/.shell/starshiprc ]] && source $HOME/.shell/starshiprc		    # Loads startship config

#set -o vi										# vi mode
shopt -s autocd										# Enable autocd (change directory just by typing its name)
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"					# Load Homebrew
eval "$(thefuck --alias)"								# Load thefuck
eval "$(direnv hook bash)"								# Load Direnv
eval "$(starship init bash)"								# Load starship prompt
pokemon-colorscripts --no-title -r 1 #,3,6 #toilet -f future -F gay "$(date +%d\ %m\ %Y)"
