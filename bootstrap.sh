#!/bin/bash

sudo apt update
sudo apt install pipx

# This bin directory will only be added to PATH if it exists, see .profile
# pipx also uses this directory to store apps, by default
mkdir -p ~/.local/bin

pipx install dotdrop
