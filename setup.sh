#!/bin/bash

# setup sudo
# 	su -
# 	apt update
# 	apt install sudo
# 	usermod -aG  sudo $USERNAME
#
#

set -e

# Standard tools
sudo apt install \
	fuse \
	libfuse2 \
	sway \
	waybar \
	firefox-esr

# Dev tools
sudo apt install \
	wget \
	curl \
	git \
	fzf \
	ripgrep \
	gcc \
	zsh

TMP_DIR="/tmp"
INSTALL_DIR="/usr/local/bin"

# Ghostty (using AppImage)
# if $(! command -v ghostty &> /dev/null); then 
# 	GHOSTTY_VERSION="1.3.1"
# 	GHOSTTY_ARCH=$(uname -m)
# 	GHOSTTY_FILE=Ghostty-${GHOSTTY_VERSION}-${GHOSTTY_ARCH}.AppImage
# 	wget https://github.com/pkgforge-dev/ghostty-appimage/releases/download/v${GHOSTTY_VERSION}/${GHOSTTY_FILE} -P /tmp/
# 	install /tmp/${GHOSTTY_FILE} /usr/local/bin/ghostty
# fi

# neovim (using AppImage)
if $(! command -v nvim &> /dev/null); then
	case "$(uname -m)" in
		x86_64)
			NVIM_FILE="nvim-linux-x86_64.appimage"
			;;
		aarch64)
			NVIM_FILE="nvim-linux-arm64.appimage"
			;;
		*)
			echo "Unsupported architecture: $ARCH"
			exit 1
			;;
	esac

	NVIM_VERSION="0.12.1"

	wget https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/${NVIM_FILE} -O ${TMP_DIR}/${NVIM_FILE}
	sudo install ${TMP_DIR}/${NVIM_FILE} ${INSTALL_DIR}/nvim
fi

# Setup zsh
if [ ! -d ${HOME}/.oh-my-zsh ]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Setup node
if $(! command -v nvm &> /dev/null); then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
	# In lieu of restarting the shell
	\. "$HOME/.nvm/nvm.sh"

	# Install node
	nvm install 22
fi

# Download tree-sitter-cli
npm install -g tree-sitter-cli

# Setup dev environment and configs
DEV_DIR=${HOME}/dev
mkdir -p ${DEV_DIR}

DOTFILES_DIR=${DEV_DIR}/dotfiles
if [ ! -d ${DOTFILES_DIR} ]; then
	git clone https://github.com/mattfan00/dotfiles.git ${DOTFILES_DIR}
fi

CONFIG_DIR=${HOME}/.config

ln -sf ${DOTFILES_DIR}/sway ${CONFIG_DIR}
ln -sf ${DOTFILES_DIR}/waybar ${CONFIG_DIR}
ln -sf ${DOTFILES_DIR}/nvim ${CONFIG_DIR}
ln -sf ${DOTFILES_DIR}/ghostty ${CONFIG_DIR}
