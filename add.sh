#!/bin/bash

# setup Ubuntu
sed -ie 's/#PasswordAuthentication\syes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -ie 's/UsePAM\syes/UsePAM no/g' /etc/ssh/sshd_config
apt update -y
apt install -y unattended-upgrades apt-listchanges
apt upgrade -y
ufw enable
ufw allow http
ufw allow https

# add apps
snap install node --channel=13/stable --classic
npm i -g yarn
snap install nvim --beta --classic
snap install microk8s --classic
snap install tree

# setup u
useradd u -ms /bin/bash
usermod -a -G sudo u
usermod -a -G microk8s u
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

# sudo passwd u
