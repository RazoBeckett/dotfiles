typeset -g ZVM_SYSTEM_CLIPBOARD_ENABLED=true
typeset -g ZVM_CLIPBOARD_COPY_CMD='wl-copy'
typeset -g ZVM_CLIPBOARD_PASTE_CMD='wl-paste'
typeset -g ZVM_OPEN_URL_CMD='zen-browser'
typeset -g ZVM_OPEN_FILE_CMD='nvim'
typeset -g ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

PLUGINPATH=/usr/share/zsh/plugins
if [[ -f $PLUGINPATH/zsh-vi-mode/zsh-vi-mode.plugin.zsh ]]; then 
  source $PLUGINPATH/zsh-vi-mode/zsh-vi-mode.plugin.zsh # Loads zsh-vi-mode
fi
