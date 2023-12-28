# /etc/zsh/zshenv : export ZDOTDIR="$HOME/.config/zsh"
# Custom scripts
[[ -f $HOME/.config/shellrc/exportrc ]] && source $HOME/.config/shellrc/exportrc 			      # Loads the $PATH Variable and Exports
[[ -f $HOME/.config/shellrc/bindkeysrc ]] && source $HOME/.config/shellrc/bindkeysrc 			  # Loads the set up the bindkeys
[[ -f $HOME/.config/shellrc/nvigpurc ]] && source $HOME/.config/shellrc/nvigpurc 			      # Loads the $PATH Variable and Exports
[[ -f $HOME/.config/shellrc/aliasesrc ]] && source $HOME/.config/shellrc/aliasesrc 			    # Loads all aliases
[[ -f $HOME/.config/shellrc/fzftricksrc ]] && source $HOME/.config/shellrc/fzftricksrc 			# Loads all functions make using fzf 
[[ -f $HOME/.config/shellrc/functionsrc ]] && source $HOME/.config/shellrc/functionsrc 		  # Loads all custom functions 
[[ -f $HOME/.config/shellrc/starshiprc ]] && source $HOME/.config/shellrc/starshiprc 			  # Loads startship config

# Plugins 
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh			                # Loads autosuggestion plugin
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh			              # Loads syntax-highlighting plugin

# History
HISTFILE=~/.cache/zsh/history
HISTSIZE=4096
SAVEHIST=4096
setopt hist_ignore_all_dups inc_append_history 

# Autocomplete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
[[ -f $HOME/.config/shellrc/lukesmithrc ]] && source $HOME/.config/shellrc/lukesmithrc      # Loads startship config

# Environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"                        # Load Homebrew
eval "$(thefuck --alias)"                                                     # Load thefuck
eval "$(starship init zsh)"                                                   # Load starship prompt
eval "$(direnv hook zsh)"                                                     # Load Direnv
pokemon-colorscripts --no-title -r 1                                          # print a random pokemon on terminal
