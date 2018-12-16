#!/usr/bin/env sh
key="$(cat ~/.ssh/id_ed25519.pub)"
echo "[ ! -d ~/.ssh ] && mkdir ~/.ssh && chmod 700 ~/.ssh; [ ! -f ~/.ssh/authorized_keys ] && touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys; echo '$key' >> ~/.ssh/authorized_keys"
