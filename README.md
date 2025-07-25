# My Personal Dotfiles

This repository contains my personal configuration files (dotfiles) for various command-line tools, including `tmux` and `neovim`.

This setup uses the "bare repository" method to manage configurations. This means the files are tracked directly in their original locations in the home directory, eliminating the need for symbolic links.

---

## What's Inside?

- **Neovim (`~/.config/nvim`):** My personal configuration for the Neovim editor.
- **Tmux (`~/.config/tmux`):** Configuration for the Tmux terminal multiplexer, including plugins managed by TPM.
- **And more...** (You can add more as you track them)

---

## Installation on a New Machine

To install these dotfiles on a new system, follow these steps.

### 1. Prerequisities

Ensure you have `git` installed on the new machine.

### 2. Clone the Bare Repository

Clone this repository into a hidden `.dotfiles` directory in your home folder.

```bash
git clone --bare git@github.com:your-username/dotfiles.git $HOME/.dotfiles
```

### 3. Define the `config` Alias

Create a temporary alias to interact with the bare repository. This alias tells Git where to find its database (`--git-dir`) and which files to track (`--work-tree`).

```bash
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

### 4. Checkout the Files

"Checkout" the repository content. This command pulls the actual configuration files from the `.dotfiles` database and places them in their correct locations throughout your home directory.

```bash
config checkout
```

**Note:** If you get an error about your files being overwritten, it means you already have default versions of those files (e.g., a default `.bashrc`). You can back them up first (`mv ~/.bashrc ~/.bashrc.bak`) and then run the `config checkout` command again.

### 5. Finalize the Setup

1.  **Make the alias permanent** so you can use the `config` command in any new terminal session. Add it to your shell's startup script (`.bashrc` for Bash, `.zshrc` for Zsh).

    ```bash
    echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> ~/.bashrc
    ```

    Then, reload your shell with `source ~/.bashrc`.

2.  **Set the repository to hide untracked files** for cleaner status reports.
    ```bash
    config config --local status.showUntrackedFiles no
    ```

### 6. Install Plugins

The final step is to let the respective plugin managers install all the necessary plugins.

- **For Tmux (TPM):** Start `tmux` and press `prefix + I` (capital 'i') to fetch all the plugins.
- **For Neovim (Packer/vim-plug):** Open `nvim` and run your plugin manager's install command (e.g., `:PackerSync` or `:PlugInstall`).

You are now all set!
