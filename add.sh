#!/bin/bash

# add user u
useradd                 \
    --shell /bin/bash   \
    --create-home       \
    u
usermod                 \
    --append            \
    --groups sudo       \
    u
cp -r ~/.ssh /home/u/
chown -R u:u /home/u/.ssh
sed -ie 's/#PasswordAuthentication\syes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -ie 's/UsePAM\syes/UsePAM no/g' /etc/ssh/sshd_config
    
# Unattended upgrades
apt-get install -y unattended-upgrades apt-listchanges
apt upgrade -y

# as user from here:
function wS() { sudo -iu u bash -c "$@"; }
wS 'mkdir /home/u/.config'
wS 'git clone https://github.com/2jj/nvim.git /home/u/.config/nvim'
wS 'ln -sf /home/u/.config/nvim/.bash_aliases /home/u/.bash_aliases'
wS 'ln -sf /home/u/.config/nvim/.tmux.conf /home/u/.tmux.conf'
wS 'ln -sf /home/u/.config/nvim/.eslintrc.yml /home/u/.eslintrc.yml'
wS 'ln -sf /home/u/.config/nvim/.prettierrc.yml /home/u/.prettierrc.yml'
wS 'git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm'
wS 'echo "if [ -z "$TMUX" ]; then" >> /home/u/.bashrc'
wS 'echo "  tmux attach -t bb || tmux new -s bb" >> /home/u/.bashrc'
wS 'echo "fi" >> /home/u/.bashrc'

# Manual stuff: pwd, nvm, node/npm, yarn, initial nvim start:
# passwd u
# su u
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash 
# exit
# su u
# cd ~
# nvm i --lts && npm i -g yarn