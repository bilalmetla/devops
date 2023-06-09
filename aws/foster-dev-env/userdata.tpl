#!/bin/bash
# Install nodejs

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
. ~/.nvm/nvm.sh

# nvm install --lts
nvm install 16

npm install pm2 -g 

