# ChezMoi Dotfiles Management

This repository contains a managed collection of dotfiles using [ChezMoi](https://www.chezmoi.io/). It is designed for flexibility, portability, and security, allowing encrypted and templated management of sensitive and machine-specific configurations.
I have designed it in such a way that you don't have to worry about accidentally commiting your secrets and keys to your own repo, should you decide to fork this and push your changes up to GitHub.

## Features

- **GPG Encryption**: Sensitive files are encrypted using GPG.
- **Templated Configurations**: Dynamic handling of GPG keys and other parameters.
- **Bootstrap Script**: Automates the initial baseline config.
- **Ignore List**: Ensures unwanted or unnecessary files are not managed by ChezMoi.

---

## Setup Instructions

### 1. Clone This Repository

Clone the repository to your machine:

```bash
git clone https://github.com/steven-mosley/dotfiles.git
cd dotfiles
```

### 2. Run the Bootstrap Script

Run the included `bootstrap-chezmoi.sh` script to set up ChezMoi:

```bash
bash scripts/bootstrap-chezmoi.sh
```

The script will:

- Display a list of current GPG keys and prompt you to enter the GPG key ID you'd like to use for encryption.
  - It is highly recommended to create a separate GPG key specifically for Chezmoi.
- Create a minimal `~/.config/chezmoi/chezmoi.yaml` configuration file.
  - This is necessary because the bootstrap script will initialize your GPG key in ~/.config/chezmoi/chezmoi.yaml that is necessary for `chezmoi apply` to create your final config.

> [!NOTE]
> I have not tested this without a GPG key set, so if you run into issues while trying to run `chezmoi apply` to apply the template, re-run the bootstrap script, and just enter a random GPG key string. Just know if you wish to use GPG encryption, you will need to modify your `~/.config/chezmoi/chezmoi.yaml` file with a valud GPG key.

### 3. Test Encryption (Optional, but Recommended)

I highly recommend testing encryption and decryption with a test file before using it on files with actual sensitive information.

To verify that GPG encryption is working:

1. Create a test file:
   ```bash
   echo "Testing" > ~/testfile
   ```
2. Add the file with encryption:
   > [!WARNING]
   > It is very important that you make sure to use the `--encrypt` flag when adding sensitive files, such as SSH keys, files that contain API keys and other sensitive information. Long as you make sure to do this and you have a valid GPG key in your Chezmoi config file you should never have an incident where you accidently commit sensitive information unencrypted.

> [!NOTE]
> Chezmoi will even warn you if you add a file without the `--encrypt` flag that appears to contain some sort of sensitive information.

```bash
chezmoi add --encrypt ~/testfile
```

3. Verify the encrypted file in the source directory:
   ```bash
   chezmoi cd
   cat encrypted_testfile.asc
   ```
   Look for `-----BEGIN PGP MESSAGE-----`.
4. Test decryption:
   ```bash
   chezmoi apply
   cat ~/testfile
   ```
   You should see the actual unencrypted contents of the file.
5. Clean everything up from testing:
   ```bash
   chezmoi destroy ~/testfile
   ```

---

## Directory Structure

- **`scripts/bootstrap-chezmoi.sh`**: The bootstrap script for setting up ChezMoi.
- **`~/.config/chezmoi/chezmoi.yaml`**: The main ChezMoi configuration file.
- **`~/.local/share/chezmoi`**: The source directory where ChezMoi stores and manages dotfiles. Dotfiles that are templated will have a tmpl

---

## Adding Files to ChezMoi

To add a file for management by ChezMoi:

```bash
chezmoi add <file-path>
```

To add a file with encryption:

```bash
chezmoi add --encrypt <file-path>
```

To remove a file from being managed by Chezmoi:

```bash
chemzoi destroy <file-path>
```

If the file is encrypted, it will destroy both the encrypted and decrypted versions.

---

## Ignore List

The following files and directories are ignored and not managed by Chezmoi:

```yaml
ignore:
  - ".cache"
  - ".local/share/trash"
  - ".config/chezmoi"
  - ".config/onedrive/items.sqlite3"
```

To update the ignore list, edit `chezmoi.yaml` and manually remove files from the source directory if needed.
Alternatively, edit ~/.local/share/chezmoi/chezmoi.yaml.tmpl and run `chezmoi apply` if you want to template your new ignore list.

The proper way to edit Chezmoi managed files is with `chezmoi edit <file-path>`, and then apply the edits with `chezmoi apply`.

> [!NOTE]
> If you do not have `vi` installed or the editor you wish to use symlinked to it will complain. You can override this by adding an `EDITOR` environment variable to your shell config, or prepend the command with `EDITOR=vim`, for example: `EDITOR=vim chezmoi edit <file-path>`

---

## Troubleshooting

### Missing GPG Key

If you encounter an error about a missing GPG key:

1. Verify your GPG key:
   ```bash
   gpg --list-secret-keys --keyid-format LONG
   ```
2. Add the key to your `chezmoi.yaml` under the `data` section:
   ```yaml
   data:
     gpg_recipient: "<your-key-id>"
   ```
3. If you do not wish to use GPG encryption, simply remove `encryption: gpg` from your `~/.local/share/chezmoi/chezmoi.yaml.tmpl` template and re-run `chezmoi apply`.

### Check Available Variables

To see all variables available to your templates:

```bash
chezmoi data
```

### Check Chezmoi Configuration

```bash
chezmoi doctor
```

---

## Future Plans

- Continue to evolve the configuration template to be more self sufficient and dynamic.

Feel free to contribute or suggest improvements by forking and creating pull requests!
