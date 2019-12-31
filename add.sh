#!/bin/bash

# setup Ubuntu
sed -ie 's/#PasswordAuthentication\syes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -ie 's/UsePAM\syes/UsePAM no/g' /etc/ssh/sshd_config
apt update -y
apt install -y unattended-upgrades apt-listchanges
apt upgrade -y

# add apps
snap install node --chankknel=13/stable --classic
npm i -g yarn
snap install nvim --beta --classic
sudo snap install microk8s --classic

# setup u
useradd u -m
usermod -aG sudo u
usermod -aG microk8s u
cp -r ~/.ssh /home/u/
chown -R u:u /home/u/.ssh
function wS() { sudo -iu u bash -c "$@"; }
wS 'mkdir /home/u/.config'
wS 'git clone https://github.com/2jj/nvim.git /home/u/.config/nvim'
wS 'ln -sf /home/u/.config/nvim/.bash_aliases /home/u/.bash_aliases'
wS 'ln -sf /home/u/.config/nvim/.tmux.conf /home/u/.tmux.conf'
wS 'ln -sf /home/u/.config/nvim/.eslintrc.yml /home/u/.eslintrc.yml'
wS 'ln -sf /home/u/.config/nvim/.prettierrc.yml /home/u/.prettierrc.yml'
wS 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm'
wS 'echo "if [ -z "$TMUX" ]; then" >> /home/u/.bashrc'
wS 'echo "  tmux attach -t main || tmux new -s main" >> /home/u/.bashrc'
wS 'echo "fi" >> /home/u/.bashrc'

# manual step: sudo passwd u::
