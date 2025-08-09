# dotfiles

## Prerequisites

- https://nixos.org/download/

## Setup

**linux**

```sh
# 初回
nix --extra-experimental-features 'nix-command flakes' \
  run home-manager/master -- \
  --extra-experimental-features 'nix-command flakes' \
  switch --flake .#linux --impure

# 2回目以降
nix run home-manager/master -- switch --flake .#linux --impure
```

**mac**

```sh
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .#mac --impure
```

## Test

```sh
act -W .github/workflows/home-manager.yaml workflow_dispatch
```

## VSCode

- [settings.json](https://gist.github.com/RyushiAok/04a683e8d6817bdd2005e867bbd49039)
- [keybindings.json](https://gist.github.com/RyushiAok/744fa2368e22e974390dd59ff9494acf)
