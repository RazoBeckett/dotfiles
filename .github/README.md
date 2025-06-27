<a href="https://archlinux.org"><img width=150 height=50 align=right src="https://archlinux.org/static/logos/archlinux-logo-light-1200dpi.7ccd81fd52dc.png"></a>

# 🏠 RazoBeckett's Dotfiles

[![GitHub repo size](https://img.shields.io/github/repo-size/RazoBeckett/dotfiles)](#)
[![YADM](https://img.shields.io/badge/managed%20with-YADM-blueviolet)](https://yadm.io/)
[![Ansible](https://img.shields.io/badge/automated%20with-Ansible-red)](https://ansible.com/)

> My personal dotfiles managed with [YADM](https://yadm.io/) and automated with Ansible

## 📋 Overview
![DOTFILES-FACE-2025-06-10_14-28](https://github.com/user-attachments/assets/5d808485-9f64-4026-b45c-ba953be29f80)


This repository contains my personal configuration files (dotfiles) for various applications and tools I use in my development environment. These dotfiles are managed using YADM for easy synchronization across machines, with system bootstrapping automated through Ansible playbooks.

**Note**: This repository includes configurations for various programs and tools that I've experimented with over time. Not all configurations represent my current active setup - some are from tools I've tried and configured but may not actively use anymore.

## 🖥️ Current Setup

### Primary Environment
- **Terminal**: [Alacritty](https://alacritty.org/) with custom keybindings for tmux integration
- **Browser**: [Zen Browser](https://zen-browser.app/) as primary browser
- **Window Manager**: [DWM (Custom Build)](https://github.com/razobeckett/dwm/#readme) for X11
- **Wayland Compositor**: [Hyprland](https://hyprland.org/) for Wayland sessions
- **Shell**: ZSH with custom configuration and plugins
- **Terminal Multiplexer**: Tmux with custom keybindings and session management

### Key Features
- **Seamless Tmux Integration**: Custom keybindings in Alacritty for effortless tmux usage
- **Smart Session Management**: Using [sesh](https://github.com/joshmedeski/sesh/#readme) for quick tmux session switching
- **Fuzzy Finding**: Extensive FZF integration for file navigation and command history
- **Modern CLI Tools**: Replacements for traditional UNIX tools (bat, eza, fd, ripgrep, etc.)

## 🛠️ What's Included

### Shell Configuration
- **ZSH** (`.config/zsh/.zshrc`): Custom shell with plugins, history, and completion
- **Bash** (`.bashrc`): Fallback shell configuration
- **Modular Shell Scripts** (`.config/shellrc/`): Shared configurations for aliases, functions, exports, and FZF tricks

### Terminal Setup
- **Alacritty** (`.config/alacritty/`): Main terminal with tmux-optimized keybindings
- **Kitty** (`.config/kitty/`): Alternative terminal configuration
- **WezTerm** (`.config/wezterm/`): Lua-based terminal configuration
- **Tmux** (`.config/tmux/`): Terminal multiplexer with custom keybindings and appearance

### Window Management
- **DWM Config**: [Custom DWM build](https://github.com/razobeckett/dwm/#readme) configurations
- **Hyprland** (`.config/hypr/`): Wayland compositor with custom keybindings
- **Picom** (`.config/picom/`): X11 compositor for transparency and effects

### Development Tools
- **Starship** (`.config/starship.toml`): Modern, fast shell prompt
- **Sesh** (`.config/sesh/`): Tmux session manager with predefined sessions
- **Git Configuration**: Version control setup and aliases

### System Automation
- **YADM Bootstrap** (`.config/yadm/bootstrap`): Automated setup script
- **Ansible Playbooks** (`.config/yadm/ansible/`): System configuration automation
  - Package installation for Arch Linux and Debian-based systems
  - System security hardening
  - User environment setup

## 🚀 Installation

### Prerequisites
- [YADM](https://yadm.io/) for dotfiles management
- [Ansible](https://www.ansible.com/) for system automation (installed automatically by bootstrap)

### Quick Setup
1. **Install YADM**:
   ```bash
   # Arch Linux
   sudo pacman -S yadm
   
   # Ubuntu/Debian
   sudo apt install yadm
   
   # macOS
   brew install yadm
   ```

2. **Clone and Setup**:
   ```bash
   yadm clone https://github.com/RazoBeckett/dotfiles.git
   yadm bootstrap
   ```

The bootstrap script will automatically:
- Install Ansible if not present
- Run the appropriate playbook for your system
- Install essential packages and tools
- Set up the development environment

### Manual Installation (Without Bootstrap)
If you prefer to install manually or the bootstrap fails:

```bash
yadm clone https://github.com/RazoBeckett/dotfiles.git

# For Arch Linux users
cd ~/.config/yadm/ansible
ansible-playbook -K -i "localhost," -c local setup.yml

# Install individual components as needed
```

## ⚙️ Configuration Highlights

### Tmux Workflow
My tmux configuration is optimized for development workflow:
- **Session Management**: Quick switching with `sesh` and `tmux-sessionizer`
- **Custom Keybindings**: Terminal-integrated keybindings for seamless usage
- **Smart Splits**: Automatic path preservation and intelligent sizing
- **File Navigation**: Integrated [yazi](https://github.com/sxyazi/yazi/#readme) file manager

### ZSH Environment
- **Plugin System**: Autosuggestions, syntax highlighting, and fzf-tab
- **Smart Completion**: Enhanced tab completion with fuzzy matching
- **History Management**: Optimized history with deduplication
- **Vi Mode**: Vim-like editing with visual indicators

### Development Environment
- **Modern CLI Tools**: 
  - `bat` instead of `cat`
  - `eza` instead of `ls`
  - `fd` instead of `find`
  - `ripgrep` instead of `grep`
  - `zoxide` instead of `cd`
- **Fuzzy Finding**: FZF integration for files, commands, and directories
- **Smart Navigation**: Quick project switching with tmux-sessionizer

### Editor Setup (external, *not included*)
- **Neovim**: Modern IDE-like experience with:
  - Custom configuration from [razobeckett/nvim](https://github.com/razobeckett/nvim/#readme)
  - LSP integration for code intelligence
  - Plugin management and optimizations
  - Custom keymaps and workflows

## 🔄 Keeping Up-to-date

### Managing Changes
```bash
# Check status
yadm status

# Add changes
yadm add .

# Commit changes
yadm commit -m "Update configuration"

# Push to repository
yadm push

# Pull changes on another machine
yadm pull
```

### Updating System Packages
The Ansible playbooks can be re-run to update system packages:
```bash
cd ~/.config/yadm/ansible
ansible-playbook -K -i "localhost," -c local setup.yml
```

## 📝 Notes

### Bootstrap Status
⚠️ **Alpha State**: The bootstrap automation is functional but not fully polished. It successfully installs and configures the basic environment, but some refinements are still needed. This is mainly due to my laziness in completing the Ansible playbook, even though it works for the essential setup.

### Configuration Philosophy
- **Modular Design**: Configurations are split into logical modules for easy maintenance
- **Cross-Platform**: Support for [Arch Linux](https://archlinux.org), [Debian](https://www.debian.org/)-based systems, and [macOS](https://en.wikipedia.org/wiki/MacOS)
- **Experimental Configs**: Some configurations are from tools I've experimented with - not all represent my current active setup

## 🙏 Acknowledgments

Special thanks to the creators and maintainers of these amazing tools that make my workflow possible:

- **[Neovim](https://neovim.io/)** - hyperextensible Vim-based text editor
- **[sesh](https://github.com/joshmedeski/sesh)** - Fast tmux session manager
- **[tmux-sessionizer](https://github.com/ThePrimeagen/.dotfiles)** - Project-based tmux session creation (script by [ThePrimeagen](https://twitch.tv/theprimeagen)
- **[starship](https://starship.rs/)** - Cross-shell prompt
- **[zoxide](https://github.com/ajeetdsouza/zoxide)** - Smarter cd command
- **[fzf](https://github.com/junegunn/fzf)** - Command-line fuzzy finder
- **[direnv](https://direnv.net/)** - Environment variable manager
- **[YADM](https://yadm.io/)** - Yet Another Dotfiles Manager
- **[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)** - Seamless navigation between vim and tmux
- **[tmux-sessionx](https://github.com/omerxx/tmux-sessionx)** - Enhanced tmux session management

And to the broader open-source community for inspiration and countless hours of development that make these tools possible.

## 📜 License

This project is open source and available under the [UNLICENSE](UNLICENSE).

---

*Feel free to explore, adapt, and make these configurations your own. Happy hacking! 🚀*
