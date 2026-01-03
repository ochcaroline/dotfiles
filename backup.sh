#!/bin/bash

dotfiles_path="$HOME/source/dotfiles"

function backup_nvim() {
    echo "Backing up ~/nvim to $dotfiles_path"

    date=$(date '+%Y%m%d_%H%M%S')
    config_backup="./nvim_$date"

    mv ./nvim "$config_backup"

    cp -r ~/nvim "$dotfiles_path"
}

echo "== nvim config backup =="
backup_nvim
