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
echo ""
echo "Installing Xcode command line tools..."
xcode-select --install

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo ""
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo ""
echo "Updating brew and casks"
# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

echo ""
echo "Installing git..."
brew install git

# Install ruby-build and rbenv
echo ""
echo "Installing rbenv..."
brew install ruby-build
brew install rbenv
RBENVINIT='eval "$(rbenv init -)"'
SOURCEFILE=''
if [[ $SHELL =~ "bash" ]]; then
    touch ~/.bash_profile
    grep -q "$RBENVINIT" ~/.bash_profile || echo "$RBENVINIT" >> ~/.bash_profile
    SOURCEFILE=~/.bash_profile
    source ~/.bash_profile
else
    if [[ $SHELL =~ "zsh" ]]; then
        touch ~/.zshrc
        grep -q "$RBENVINIT" ~/.zshrc || echo "$RBENVINIT" >> ~/.zshrc
        SOURCEFILE=~/.zshrc
        source ~/.zshrc
    else
        unset SOURCEFILE
        echo "Unable to determine your shell... attempting to continue"
    fi
fi

echo ""
echo "Configuring rbenv..."
rbenv install 2.5.0
rbenv global 2.5.0
rbenv rehash

echo ""
echo "Installing Cocoapods..."
gem install cocoapods

echo ""
echo "Rehashing..."
rbenv rehash

echo ""
echo "Installing bundler..."
gem install bundler
bundle install

if [ ! -z "$SOURCEFILE" ]; then
    . $SOURCEFILE
fi
echo ""
echo "Complete."
