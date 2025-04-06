#!/bin/bash
sudo apt update
sudo apt full-upgrade
sudo apt autoremove
sudo apt install neovim
sudo apt install tmux
sudo apt install i3
sudo apt-get install ruby-full
gem install colorls
sudo apt install nodejs npm
sudo apt install luarocks
sudo luarocks install luacheck
sudo apt-get install git python3 golang
go install golang.org/x/tools/gopls@latest
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip && \
cd ~/.local/share/fonts && \
unzip JetBrainsMono.zip && \
rm JetBrainsMono.zip && \
fc-cache -fv
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm lazygit && rm lazygit.tar.gz
sudo apt install fd-find
sudo apt install fzf
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.oh-my-zsh/custom/plugins/zsh-history-substring-search
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
source ~/.zshrc

