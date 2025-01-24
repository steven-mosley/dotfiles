#!/bin/bash

# Display list of GPG keys
gpg --list-secret-keys --keyid-format LONG
echo "Copy and paste the GPG key ID under the 'sec' field (e.g., 3AA5C34371567BD2) that you want to use for encryption and paste below."

# Prompt for a GPG key
read -p "Enter your GPG key ID (or leave blank to skip encryption): " GPG_KEY

# Create the bootstrap ChezMoi config
mkdir -p ~/.config/chezmoi
cat >~/.config/chezmoi/chezmoi.yaml <<EOF
sourceDir: ~/.local/share/chezmoi
encryption: gpg

data:
  gpg_recipient: "$GPG_KEY"

ignore:
  - ".cache"
  - ".local/share/trash"
  - ".config/chezmoi"
  - ".config/onedrive/items.sqlite3"
EOF

echo "Chezmoi has been successfully bootstrapped at ~/.config/chezmoi/chezmoi.yaml."
