# Custom scripts
[[ -f $HOME/.shell/exportrc ]] && source $HOME/.shell/exportrc 			      # Loads the $PATH Variable and Exports
[[ -f $HOME/.shell/bindkeysrc ]] && source $HOME/.shell/bindkeysrc 			# Loads the set up the bindkeys
[[ -f $HOME/.shell/nvigpurc ]] && source $HOME/.shell/nvigpurc 			      # Loads the $PATH Variable and Exports
[[ -f $HOME/.shell/aliasesrc ]] && source $HOME/.shell/aliasesrc 			    # Loads all aliases
[[ -f $HOME/.shell/fzftricksrc ]] && source $HOME/.shell/fzftricksrc 			# Loads all aliases
[[ -f $HOME/.shell/functionsrc ]] && source $HOME/.shell/functionsrc 		  # Loads all custom functions 
[[ -f $HOME/.shell/starshiprc ]] && source $HOME/.shell/starshiprc 			  # Loads startship config

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

# Environment
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"                        # Load Homebrew
eval "$(thefuck --alias)"                                                     # Load thefuck
eval "$(starship init zsh)"                                                   # Load starship prompt
eval "$(direnv hook zsh)"                                                     # Load Direnv
pokemon-colorscripts --no-title -r 1                                          # print a random pokemon on terminal
