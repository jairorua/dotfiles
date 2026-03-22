# --- Shell Options ---
# Enable auto-completion
autoload -Uz compinit
compinit

# Better history handling
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Better directory navigation (typing '..' instead of 'cd ..')
setopt AUTO_CD

# --- Keybindings ---
# Fix Home/End/Delete keys in Ghostty/Zsh
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

# --- Prompt ---
# A simple, clean prompt: [user@host directory] %
# PROMPT='%F{blue}%n@%m %F{yellow}%~%F{white}%f: '
# Handled by starship

# --- Aliases ---
# Arch & System
alias grep='grep --color=auto'
alias update='sudo pacman -Syu'
alias install='sudo pacman -S'

# Hyprland specific
alias conf='nvim ~/.config/hypr/hyprland.conf'
alias reload='hyprctl reload'

# Ghostty/Editor
alias v='nvim' # or 'nano' or 'code'

# Replace standard commands with modern tools
alias cd="z"
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias cat="bat --style=plain"

# Bare repository function for dotfiles
dotfilesconfig() {
  /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"
}

# --- Plugins (Optional) ---
# For syntax highlighting, install:
# sudo pacman -S zsh-syntax-highlighting
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Initialize Starship prompt
eval "$(starship init zsh)"

# Initialize Zoxide (Better 'cd')
eval "$(zoxide init zsh)"

# --- Paths ---
# Golang Path
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# --- TMUX ---
# Fix tmux Wayland environment variables on attach
if [ -n "$TMUX" ]; then
    # Grab the active Hyprland instance and Wayland display from the system
    export HYPRLAND_INSTANCE_SIGNATURE=$(ls -1 $XDG_RUNTIME_DIR/hypr | head -n 1)
    export WAYLAND_DISPLAY=$(ls -1 $XDG_RUNTIME_DIR | grep -Eo 'wayland-[0-9]+' | head -n 1)
fi
