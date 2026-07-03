#!/bin/bash

echo "🚀 Starting modern terminal ecosystem installation..."

# ====================================================================
# ARCHITECTURE DETECTION
# ====================================================================
ARCH=$(uname -m)
IS_PI=false

if [[ "$ARCH" == "aarch64" || "$ARCH" == "armv7l" ]]; then
    echo "🍉 Raspberry Pi / ARM environment detected ($ARCH)."
    IS_PI=true
else
    echo "💻 Standard x86_64 environment detected ($ARCH)."
fi

# ====================================================================
# 1. INSTALL SYSTEM DEPENDENCIES
# ====================================================================
sudo apt update && sudo apt install -y uidmap build-essential unzip git curl ripgrep fd-find xclip zsh eza bat

# ====================================================================
# 2. CHANGE DEFAULT SHELL
# ====================================================================
chsh -s $(which zsh)

# ====================================================================
# 3. install zsh from git 
# ====================================================================
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install


# ====================================================================
# 4. CLONE THIRD-PARTY TOOLS
# ====================================================================
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting 2>/dev/null || true

# ====================================================================
# 5. INSTALL STARSHIP
# ====================================================================
curl -sS https://starship.rs/install.sh | sh -s -- -y

# ====================================================================
# 6. CONDITIONAL NEOVIM INSTALLATION
# ====================================================================
if [ "$IS_PI" = true ]; then
        echo "📦 Installing Neovim via APT for ARM compatibility..."
	# 1. Download the ARM64 pre-compiled binary for your Raspberry Pi
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.appimage
	
	# 2. Make it executable
	chmod +x nvim-linux-arm64.appimage
	
	# 3. Move it to your local bin folder
	sudo mv nvim-linux-arm64.appimage /usr/local/bin/nvim
else
    echo "📥 Downloading official x86_64 Neovim release v0.10+..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    rm nvim-linux-x86_64.tar.gz
    
    # We only append this to the system path if it's an x86 machine 
    # (Since APT installs it directly to /usr/bin on the Pi)
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
fi

# Fetch the base LazyVim structure (Symlink handles custom configs)
if [ ! -d ~/.config/nvim/.git ]; then
    git clone https://github.com/LazyVim/starter ~/.config/nvim
fi

# ====================================================================
# 3. CREATE SYMLINKS
# ====================================================================
ln -sf ~/dotfiles/zshrc ~/.zshrc
mkdir -p ~/.config/tmux
ln -sf ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf

mkdir -p ~/.config/nvim
ln -sf ~/dotfiles/nvim-lua ~/.config/nvim/lua
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
echo "✅ Installation complete! Please restart your terminal or type 'zsh'."
echo "Remember to reload tmux - CTRL+b CTRL+I"
