# /etc/zsh/zshenv : export ZDOTDIR="$HOME/.config/zsh"
alias zshconfig="nvim $ZDOTDIR/.zshrc"

# Custom scripts
[[ -f $HOME/.config/shellrc/exportrc ]] && source $HOME/.config/shellrc/exportrc 			      # Loads the $PATH Variable and Exports
[[ -f $HOME/.config/shellrc/bindkeys.zsh ]] && source $HOME/.config/shellrc/bindkeys.zsh    # Loads the set up the bindkeys
[[ -f $HOME/.config/shellrc/aliasesrc ]] && source $HOME/.config/shellrc/aliasesrc 			    # Loads all aliases
[[ -f $HOME/.config/shellrc/fzftricksrc ]] && source $HOME/.config/shellrc/fzftricksrc 			# Loads all functions make using fzf 
[[ -f $HOME/.config/shellrc/functionsrc ]] && source $HOME/.config/shellrc/functionsrc 		  # Loads all custom functions 

# Plugins 
PLUGINPATH=/usr/share/zsh/plugins
[[ -f $PLUGINPATH/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]] && source $PLUGINPATH/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh			                # Loads autosuggestion plugin
[[ -f $PLUGINPATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source $PLUGINPATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh			              # Loads syntax-highlighting plugin

WAKATIME_HOME=${XDG_CONFIG_HOME}/wakatime
# History
HISTFILE=${XDG_STATE_HOME}/zsh/history
HISTSIZE=4096
SAVEHIST=4096
setopt hist_ignore_all_dups inc_append_history 

# Autocomplete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
[[ -f $HOME/.config/shellrc/lukesmithrc ]] && source $HOME/.config/shellrc/lukesmithrc      # Loads vim (cursor) mode indicator

# Environment
eval "$(fzf --zsh)"                                                           # Load fzf
eval "$(zoxide init zsh)"                                                     # Load zoxide
eval "$(starship init zsh)"                                                   # Load starship prompt
