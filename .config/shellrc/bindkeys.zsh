#!/usr/bin/zsh
alias zshbinds='vim ~/.config/shellrc/bindkeys.zsh'

# zsh specific configuration
alias background='setsid -f'
alias -s {py,PY}='python'
alias -s {pdf,PDF}='background mupdf'
alias -s {txt,TXT,md,MD}='vim'
alias -s {jpg,JPG,jpeg,JPEG,png,PNG}='background feh'
alias -s {mp3,MP3,flac,FLAC}='background mpv'
alias -s {mp4,MP4,avi,AVI,mkv,MKV}='background mpv'
alias -s {doc,DOC,docx,DOCX,odt,ODT}='background libreoffice'
alias -s {xls,XLS,xlsx,XLSX,ods,ODS}='background libreoffice'
alias -s {ppt,PPT,pptx,PPTX,odp,ODP}='background libreoffice'
alias -s {html,HTML,htm,HTM}='background firefox'
alias -s {zip,ZIP,tar,TAR,tar.gz,TAR.GZ,tar.bz2,TAR.BZ2}='tar -xvf'
alias -s {rar,RAR}='unrar x'
alias -s {7z,7Z}='7z x'
alias -s {deb,DEB}='sudo dpkg -i'
alias -s {rpm,RPM}='sudo rpm -i'
alias -s {iso,ISO}='sudo mount -o loop'
alias -s {torrent,TORRENT}='transmission-remote -a'
alias -s {cbr,CBR,cbz,CBZ}='comix'
alias -s {epub,EPUB}='background fbreader'

# configure key keybindings
bindkey ' ' magic-space                           # do history expansion on space
bindkey '^U' backward-kill-line                   # ctrl + U
bindkey '^[[3;5~' kill-word                       # ctrl + Supr
bindkey '^[[3~' delete-char                       # delete
bindkey '^[[1;5C' forward-word                    # ctrl + ->
bindkey '^[[1;5D' backward-word                   # ctrl + <-
bindkey '^[[5~' beginning-of-buffer-or-history    # page up
bindkey '^[[6~' end-of-buffer-or-history          # page down
bindkey '^[[H' beginning-of-line                  # home
bindkey '^[[F' end-of-line                        # end
bindkey '^[[Z' undo                               # shift + tab undo last action

# custom keybindings
bindkey -s '^R' 'history\n'                       # ctrl + R to search history
bindkey -s '^]' 'tmux-sessionizer\n'              # ctrl + ] to open tmux sessionizer
