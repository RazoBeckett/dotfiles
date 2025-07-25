#     _________  _   _ ____   ____ 
#    |__  / ___|| | | |  _ \ / ___|
#      / /\___ \| |_| | |_) | |    
#     / /_ ___) |  _  |  _ <| |___ 
#    /____|____/|_| |_|_| \_\\____|
#
# https://github.com/razobeckett/dotfiles

# /etc/zsh/zshenv : export ZDOTDIR="$HOME/.config/zsh"
alias zshconfig="nvim $ZDOTDIR/.zshrc"

# Custom scripts
CS=$HOME/.config/shellrc
# [[ -f $CS/ssh-agentrc ]] && source $CS/ssh-agentrc      # Loads up ssh-agent
[[ -f $CS/exportrc ]] && source $CS/exportrc            # Loads the $PATH Variable and Exports
[[ -f $CS/bindkeys.zsh ]] && source $CS/bindkeys.zsh    # Loads the set up the bindkeys
[[ -f $CS/aliasesrc ]] && source $CS/aliasesrc          # Loads all aliases
[[ -f $CS/fzftricksrc ]] && source $CS/fzftricksrc      # Loads all functions make using fzf 
[[ -f $CS/functionsrc ]] && source $CS/functionsrc      # Loads all custom functions 
[[ -f $CS/widgets.zsh ]] && source $CS/widgets.zsh      # Loads all custom widgets (keybind overrides) 

# Plugins 
PLUGINPATH=/usr/share/zsh/plugins
[[ -f $PLUGINPATH/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]] && source $PLUGINPATH/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh     # Loads autosuggestion plugin
[[ -f $PLUGINPATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source $PLUGINPATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh   # Loads syntax-highlighting plugin

WAKATIME_HOME=${XDG_CONFIG_HOME}/wakatime

# History
HISTSIZE=50000
HISTFILE=${XDG_STATE_HOME}/zsh/history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt inc_append_history
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_dups hist_ignore_all_dups
setopt hist_find_no_dups hist_save_no_dups

# Autocomplete
autoload -U compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
#zmodload zsh/complist
#_comp_options+=(globdots)
[[ -f $PLUGINPATH/fzf-tab/fzf-tab.plugin.zsh ]] && source $PLUGINPATH/fzf-tab/fzf-tab.plugin.zsh    # Loads fzf-tab plugin
[[ -f $HOME/.config/shellrc/lukesmithrc ]] && source $HOME/.config/shellrc/lukesmithrc              # Loads vim (cursor) mode indicator
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm

# direnv
export DIRENV_LOG_FORMAT=""
eval "$(direnv hook zsh)"        # Load direnv

# Environment
eval "$(fzf --zsh)"              # Load fzf
eval "$(zoxide init zsh)"        # Load zoxide
eval "$(atuin init zsh --disable-up-arrow)" || echo "failed"

eval "$(starship init zsh)"      # Load starship prompt
TRANSIENT_PROMPT="${PROMPT// prompt / prompt --profile transient }"
autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-finish transient-prompt
function transient-prompt() {
    PROMPT="$TRANSIENT_PROMPT" RPROMPT="$TRANSIENT_RPROMPT" zle .reset-prompt
}

#eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/config.toml)"      # Load oh-my-posh prompt
