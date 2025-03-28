# install process

clone repository to ~/dotfiles/
[Neovim Install Guide](https://github.com/neovim/neovim/blob/master/INSTALL.md)
download oh-my-zsh\

### Nvim LSPs

download npm and luarocks then hit :MasonInstall in nvim

## change to zsh

sudo chsh -s $(which zsh)

## plugins install:

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/MichaelAquilina/zsh-auto-notify.git $ZSH_CUSTOM/plugins/auto-notify
git clone https://github.com/MichaelAquilina/zsh-you-should-use ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/you-should-use

## download colorls

sudo gem install colorls
https://github.com/athityakumar/colorls

## tmux

### tpm install

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

### nerdfont install for catpuccin

wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv

## Download Ghostty

good luck!! no help here figure it out
just kidding go to this page https://ghostty.org/docs/install/build and download zig and then clone ghostty and use zig to build it. or use ubuntu package manager but not that good in my opinion. building makes sure you get the latest version but no updates
stow . to apply configuiration in dotfiles
