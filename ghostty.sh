#!/bin/bash
sudo apt update
sudo apt install snapd -y
export PATH=$PATH:/snap/bin
source ~/.bashrc
source ~/.zshrc
snap install zig --classic --beta
sudo apt install libgtk-4-dev libadwaita-1-dev git blueprint-compiler gettext libxml2-utils
git clone https://github.com/ghostty-org/ghostty
cd ghostty
zig build -Doptimize=ReleaseFast
sudo mv ~/ghostty/zig-out/bin/ghostty /usr/local/bin/


