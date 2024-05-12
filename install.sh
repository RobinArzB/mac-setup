#!/bin/bash

set -e
set -x

echo "Checking for Homebrew..."
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Adding Homebrew to PATH..."
    echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
else
    echo "Homebrew is already installed."
fi

echo "Updating Homebrew..."
brew update

echo "Installing required packages..."
brew install make cmake git \
    gettext libtool autoconf automake pkg-config unzip \
    openssl readline sqlite3 wget curl llvm ncurses \
    xz libffi python3

echo "Installing common CLI tools..."
brew install zsh ripgrep tmux \
    btop node npm rsync bat fzf jq \
    tree pass atuin cloc watch direnv

echo "Installing desktop applications..."
brew install --cask visual-studio-code raycast \
    flameshot

echo "Creating necessary directories..."
mkdir -p ~/build
mkdir -p ~/git

echo "Checking if Neovim is already installed..."
# Neovim from source
if ! [ -d $HOME/build/neovim ]; then
    echo "Cloning Neovim..."
    git clone https://github.com/neovim/neovim ~/build/neovim
    cd ~/build/neovim/
    echo "Building Neovim..."
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    echo "Installing Neovim..."
    sudo make install
else
    echo "Neovim is already installed."
fi

echo "Setting up Mise-en-Place..."
if ! command -v ~/.local/bin/mise &>/dev/null; then
    echo "Mise en Place is not installed. Installing now..."
    curl https://mise.run | sh
    echo "Configuring Mise en Place..."
    echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
else
    echo "Mise en Place is already installed."
fi
echo "Setting up Python environment..."
# Python tools
if ! [ -d $HOME/.pyenv ]; then
  echo "Installing Pyenv..."
  curl https://pyenv.run | bash
else
  echo "Pyenv is already installed."
fi

echo "Checking if Rust is installed..."
# Rust tools
if ! [ -x "$(command -v cargo)" ]; then
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
  echo "Rust is already installed."
fi

echo "Installing 'uv' - Python package installer..."
# uv | python package installer
if ! command -v uv &> /dev/null ; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv is already installed."
fi

echo "Setting up Starship prompt"
if ! [ -x "/usr/local/bin/starship" ]; then
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init zsh)"' >> ~/.zshrc

echo "Installation completed!"
