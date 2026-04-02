#!/usr/bin/env bash

set -euxo pipefail

setup-cargo() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --no-modify-path
}

install-difftastic() {
  tmp=$(mktemp -d)
  curl -L https://github.com/daylinmorgan/difftastic/archive/refs/heads/0.68.0-nim.tar.gz \
  | tar xz -C "$tmp"
  cargo install --path "$tmp/difftastic-0.68.0-nim"
  rm -rf "$tmp"
}

setup-npm() {
  fnm use default
}

install-pi() {
  npm install -g git+https://git.dayl.in/daylin/pi.git
}

setup-cargo
install-difftastic

setup-npm
install-pi
