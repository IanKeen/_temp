#!/usr/bin/env bash

echo "Configuring development environment"
echo ""
echo "This may take some time..."
echo ""
echo "Before continuing ensure you have Xcode installed and you have opened it and accepted the User Agreement"
read -p "then press [Return] to continue..."

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Ensure latest xcode tools
echo "Installing Xcode command line tools..."
xcode-select --install >/dev/null

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" >/dev/null
fi

echo "Updating brew and casks"
# Make sure we’re using the latest Homebrew.
brew update >/dev/null

# Upgrade any already-installed formulae.
brew upgrade >/dev/null

echo "Installing git..."
brew install git >/dev/null

# Install ruby-build and rbenv
echo "Installing rbenv..."
brew install ruby-build >/dev/null
brew install rbenv >/dev/null
RBENVINIT='eval "$(rbenv init -)"'
if [[ $SHELL =~ "bash" ]]; then
    touch ~/.bash_profile
    grep -q "$RBENVINIT" ~/.bash_profile || echo "$RBENVINIT" >> ~/.bash_profile
    source ~/.bash_profile
else
    if [[ $SHELL =~ "zsh" ]]; then
        touch ~/.zshrc
        grep -q "$RBENVINIT" ~/.zshrc || echo "$RBENVINIT" >> ~/.zshrc
        source ~/.zshrc
    else
        echo "Unable to determine your shell... attempting to continue"
    fi
fi

echo "Configuring rbenv..."
rbenv install 2.5.0 >/dev/null
rbenv global 2.5.0 >/dev/null
rbenv rehash >/dev/null

echo "Installing Cocoapods..."
gem install cocoapods >/dev/null

echo "Rehashing..."
rbenv rehash >/dev/null

echo "Installing bundler..."
gem install bundler >/dev/null
bundle install >/dev/null

echo "Complete."
