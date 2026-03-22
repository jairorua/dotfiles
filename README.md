# My Personal Dotfiles

This repository contains my personal configuration files (dotfiles) for various command-line tools, including `tmux`, `ghostty` and `neovim`, and my `Arch-Hyprland` setup.

This setup uses the "bare repository" method to manage configurations. This means the files are tracked directly in their original locations in the home directory, eliminating the need for symbolic links.

---

## What's Inside?

- **Neovim (`~/.config/nvim`):** My personal configuration for the Neovim editor.
- **Tmux (`~/.config/tmux`):** Configuration for the Tmux terminal multiplexer, including plugins managed by TPM.
- **Ghostty (`~/.config/ghostty`):** Configuration for Ghostty termnial.
- **Hyprland configs (~/.config/hypr/):** Window manager configuration and scripts
- **Rofi (~/.config/rofi/):** Application launcher configuration
- **SwayNC (~/.config/swaync/):** Notification daemon configuration
- **Waybar (~/.config/waybar/):** Status bar configuration
- **Zathura (~/.config/zathura/):** PDF viewer configuration
- **GTK & theming configs:** ~/.config/gtk-3.0/, ~/.config/gtk-4.0/, ~/.config/nwg-look/
- **Starship (~/.config/starship.toml):** Shell prompt configuration
- **Zsh (~/.zshrc):** Shell configuration
- **Thunar (~/.config/Thunar/):** File manager preferences

---

## Installation on a New Machine

To install these dotfiles on a new system, follow these steps.

### 1. Prerequisities

- Ensure you have `git` installed on the new machine
- A shell (Zsh recommended, see `~/.zshrc`)

### 2. Clone the Bare Repository

Clone this repository into a hidden `.dotfiles` directory in your home folder.

```bash
git clone --bare git@github.com:jairorua/dotfiles.git $HOME/.dotfiles
```

### 3. Define the `dotfilesconfig` Function

Create a function to interact with the bare repository. This tells Git where to find its database (`--git-dir`) and which files to track (`--work-tree`).

Zsh (Recommended, `~/.zshrc`)

```bash
dotfilesconfig() {
git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"
}
```

Bash

```bash
dotfilesconfig() {
git --git-dir=$HOME/.dotfiles --work-tree=$HOME "$@"
}
```

Then reload your shell:

`source ~/.zshrc`

### 4. Checkout the Files

"Checkout" the repository content. This command pulls the actual configuration files from the `.dotfiles` database and places them in their correct locations throughout your home directory.

```bash
dotfilesconfig checkout
```

**Note:** If you get an error about your files being overwritten, it means you already have default versions of those files (e.g., a default `.bashrc`). You can back them up first (`mv ~/.bashrc ~/.bashrc.bak`) and then run the `config checkout` command again.

### 5. Add and Track the Config Files

To add your existing configs into the repository, run:

#### Core Hyprland files (including scripts)

```bash
dotfilesconfig add ~/.config/hypr/hyprpaper.conf
dotfilesconfig add ~/.config/hypr/hyprlock.conf
dotfilesconfig add ~/.config/hypr/hypridle.conf
dotfilesconfig add ~/.config/hypr/scripts/monitor_switch.sh
```

#### GUI tool configs

```bash
dotfilesconfig add ~/.config/nvim/
dotfilesconfig add ~/.config/tmux/
dotfilesconfig add ~/.config/ghostty/
dotfilesconfig add ~/.config/rofi/
dotfilesconfig add ~/.config/swaync/
dotfilesconfig add ~/.config/waybar/
dotfilesconfig add ~/.config/zathura/
```

#### Appearance and shell

```bash
dotfilesconfig add ~/.config/starship.toml
dotfilesconfig add ~/.config/nwg-look/
dotfilesconfig add ~/.config/gtk-3.0/
dotfilesconfig add ~/.config/gtk-4.0/
dotfilesconfig add ~/.zshrc
```

#### File manager preferences

```bash
dotfilesconfig add ~/.config/Thunar/
```

Then commit and push:

```bash
dotfilesconfig commit -m "Add full desktop configuration"
dotfilesconfig push
```

---

### 6. Finalize the Setup

```bash
dotfilesconfig config -local status.showUntrackedFiles no
```

---

#### Usage (Daily Workflow)

```bash
dotfilesconfig status
dotfilesconfig add <file>
dotfilesconfig commit -m "message"
dotfilesconfig push
```

#### Important Notes

Always use:

```bash
dotfilesconfig <command>
```

Never use plain `git` inside your home directory.

#### Install Plugins

The final step is to let the respective plugin managers install all the necessary plugins.

- **For Tmux (TPM):** Start `tmux` and press `prefix + I` (capital 'i') to fetch all the plugins.
- **For Neovim (Lazy):** The first time you open `nvim`, Lazy.nvim should automatically start installing all the plugins. If it doesn't, or to sync plugins later, run the command `:Lazy sync`.

You are now all set!
