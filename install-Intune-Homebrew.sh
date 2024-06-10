#!/bin/zsh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
sudo grep -q '%admin ALL=(ALL) NOPASSWD:SETENV: /opt/homebrew/*/* *, /usr/sbin/installer -pkg /opt/homebrew/*, /bin/launchctl list *' /etc/sudoers || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | sudo tee -a /etc/zprofile > /dev/null
sudo chown -R :admin /opt/homebrew
sudo chmod -R 775 /opt/homebrew
sudo grep -q 'eval "\$(/opt/homebrew/bin/brew shellenv)"' /etc/zprofile || echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' | sudo tee -a /etc/zprofile > /dev/null
source /etc/zprofile
brew install --cask intune-company-portal
open /Applications/Company\ Portal.app