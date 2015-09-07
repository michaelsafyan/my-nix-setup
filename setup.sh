#! /bin/bash

REPOSITORY_BASE_URL="https://raw.githubusercontent.com/michaelsafyan/my-nix-setup/master"

function mynixsetup__Install() {
    mynixsetup__Log "======================================="
    mynixsetup__Log "==         My *NIX Setup             =="
    mynixsetup__Log "======================================="
    mynixsetup__Log ""
    mynixsetup__Log "Initiating install process..."

    local temp_directory=$(mktemp -dt "my-nix-setup-XXXXXX")
    mkdir -p "$temp_directory"
    
    mynixsetup__Log "Downloading my-nix-setup tarball..."
    curl "$REPOSITORY_BASE_URL/my-nix-setup.tar.bz2" --fail  --output "$temp_directory/my-nix-setup.tar.bz2" || mynixsetup__Fatal "Could not download my-nix-setup.tar.bz2"

    local backup_folder="$temp_directory/backup"
    mkdir -p "$backup_folder"
    
    mynixsetup__Log "Extracting downloaded archive..."
    (cd "$temp_directory" >/dev/null && tar -xjf "my-nix-setup.tar.bz2") || mynixsetup__Fatal "Could not extract downloaded archive"
    (cd "$temp_directory" && chmod -R a+x my-nix-setup) || mynixsetup__Fatal "Could not make extracted files executable"
    mynixsetup__BackUpAndDeleteIfExists "$backup_folder" "$HOME/.my-nix-setup" "previous-my-nix-setup"
    mv "$temp_directory/my-nix-setup" "$HOME/.my-nix-setup"
    mynixsetup__Log "Extracted to: $HOME/.my-nix-setup"

    mynixsetup__BackUpAndDeleteIfExists "$backup_folder" "$HOME/.bashrc" "bashrc.bak"
    mynixsetup__BackUpAndDeleteIfExists "$backup_folder" "$HOME/.profile" "profile.bak"
    mynixsetup__BackUpAndDeleteIfExists "$backup_folder" "$HOME/.bash_profile" "bash_profile.bak"

    mynixsetup__Log "Replacing: $HOME/.profile"
    echo 'source "$HOME/.my-nix-setup/etc/profile.sh"' > "$HOME/.profile"

    mynixsetup__Log "Replacing: $HOME/.bashrc"
    echo 'source "$HOME/.my-nix-setup/etc/bashrc.sh"' > "$HOME/.bashrc"
    
    mynixsetup__Log ""
    mynixsetup__Log "Installation complete!"
    mynixsetup__Log "Please open a new terminal for the changes to take effect."
}

function mynixsetup__Delete() {
    mynixsetup__Log "Deleting: $1"
#    rm -rf "$1" || mynixsetup__Fatal "Could not delete: $1"
}

function mynixsetup__DeleteIfExists() {
    if [ -e "$1" ]  ; then
      mynixsetup__Delete "$1"
    fi
}

function mynixsetup__CreateDirectory() {
    mynixsetup__Log "Creating directory: $1"
    mkdir -p "$1" || mynixsetup__Fatal "Could not create directory: $1"
}

function mynixsetup__BackUp() {
    local backup_folder="$1"
    local file_to_backup="$2"
    local backup_path="$3"
    mynixsetup__Log "Backing up: $file_to_backup => $backup_folder/$backup_path"
    cp -rf "$file_to_backup" "$backup_folder/$backup_path"
}

function mynixsetup__BackUpIfExists() {
    local backup_folder="$1"
    local file_to_backup="$2"
    local backup_path="$3"
    if [ -e "$file_to_backup" ] ; then
      mynixsetup__BackUp "$backup_folder" "$file_to_backup" "$backup_path"
    else
      mynixsetup__Log "Skipping backup (does not exist): $file_to_backup"
    fi
}

function mynixsetup__BackUpAndDeleteIfExists() {
    local backup_folder="$1"
    local file_to_backup="$2"
    local backup_path="$3"
    if [ -e "$file_to_backup" ] ; then
      mynixsetup__BackUp "$backup_folder" "$file_to_backup" "$backup_path"
      mynixsetup__Delete "$file_to_backup"
    fi
}

function mynixsetup__Log() {
    echo "$@" >&2
}

function mynixsetup__Fatal() {
    echo "Fatal error: $@" >&2
    exit 1
}


mynixsetup__Install