#!/bin/bash

# Create directory for storing different configs if it doesn't exist
mkdir -p ~/.config/nvim-configs

backup_current_config() {
    if [ -d ~/.config/nvim ]; then
        echo "Backing up current config..."
        cp -r ~/.config/nvim ~/.config/nvim-configs/custom_backup
    fi
}

restore_custom_config() {
    if [ -d ~/.config/nvim-configs/custom_backup ]; then
        echo "Restoring custom config..."
        rm -rf ~/.config/nvim
        cp -r ~/.config/nvim-configs/custom_backup ~/.config/nvim
    else
        echo "No backup found!"
    fi
}

setup_nvchad() {
    echo "Setting up NvChad..."
    rm -rf ~/.config/nvim
    rm -rf ~/.local/share/nvim
    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
}

setup_astronvim() {
    echo "Setting up AstroNvim..."
    rm -rf ~/.config/nvim
    rm -rf ~/.local/share/nvim
    git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
}

setup_lazyvim() {
    echo "Setting up LazyVim..."
    rm -rf ~/.config/nvim
    rm -rf ~/.local/share/nvim
    git clone https://github.com/LazyVim/starter ~/.config/nvim
}

# Usage examples in comments:
# ./nvim-config-switch.sh backup    # Backup current config
# ./nvim-config-switch.sh nvchad    # Switch to NvChad
# ./nvim-config-switch.sh astro     # Switch to AstroNvim
# ./nvim-config-switch.sh lazy      # Switch to LazyVim
# ./nvim-config-switch.sh restore   # Restore custom config

case "$1" in
    "backup")
        backup_current_config
        ;;
    "nvchad")
        backup_current_config
        setup_nvchad
        ;;
    "astro")
        backup_current_config
        setup_astronvim
        ;;
    "lazy")
        backup_current_config
        setup_lazyvim
        ;;
    "restore")
        restore_custom_config
        ;;
    *)
        echo "Usage: $0 {backup|nvchad|astro|lazy|restore}"
        exit 1
        ;;
esac
