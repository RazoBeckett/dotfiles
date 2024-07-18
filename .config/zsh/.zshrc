#     _________  _   _ ____   ____ 
#    |__  / ___|| | | |  _ \ / ___|
#      / /\___ \| |_| | |_) | |    
#     / /_ ___) |  _  |  _ <| |___ 
#    /____|____/|_| |_|_| \_\\____|
#
# https://github.com/razobeckett/dotfiles

# /etc/zsh/zshenv : export ZDOTDIR="$HOME/.config/zsh"
alias zshconfig="nvim $ZDOTDIR/.zshrc"

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    eval $(ssh-agent -s) > /dev/null
    ssh-add ~/.ssh/git
    clear
fi

# Custom scripts
[[ -f $HOME/.config/shellrc/exportrc ]] && source $HOME/.config/shellrc/exportrc            # Loads the $PATH Variable and Exports
[[ -f $HOME/.config/shellrc/bindkeys.zsh ]] && source $HOME/.config/shellrc/bindkeys.zsh    # Loads the set up the bindkeys
[[ -f $HOME/.config/shellrc/aliasesrc ]] && source $HOME/.config/shellrc/aliasesrc          # Loads all aliases
[[ -f $HOME/.config/shellrc/fzftricksrc ]] && source $HOME/.config/shellrc/fzftricksrc      # Loads all functions make using fzf 
[[ -f $HOME/.config/shellrc/functionsrc ]] && source $HOME/.config/shellrc/functionsrc      # Loads all custom functions 

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

# Environment
eval "$(fzf --zsh)"              # Load fzf
eval "$(zoxide init zsh)"        # Load zoxide
eval "$(starship init zsh)"      # Load starship prompt
#eval "$(oh-my-posh init zsh --config $HOME/.config/oh-my-posh/config.toml)"      # Load oh-my-posh prompt
