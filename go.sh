#!/bin/bash
sudo apt install git curl tree dialog -y
mkdir ~/github
read -p "Saisissez l'adresse mail utilisée avec votre compte Github : " email
read -p "Saisissez le nom du compte github : " gaccount
read -p "Saisissez le token que vous as fournis Github : " token

rm ~/.ssh/id_ed25519*
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_ed25519 -C "$email" -N ""

git config --global user.email "$email"
git config --global user.name "$gaccount"
git config --global init.defaultBranch main
dt=$(date '+%Y-%m-%d')

curl -X POST -H "Authorization: token $token" \
             -d '{"title" : "SSH_Key '$dt'  Plateforme", "key" : "'"$(cat "$HOME"/.ssh/id_ed25519.pub)"'"}' \
             https://api.github.com/user/keys

sed -i '/export Git_Token/d' ~/.bashrc
echo 'export Git_Token="'$token'"' >> ~/.bashrc
source ~/.bashrc
cd ~/github
