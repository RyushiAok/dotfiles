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
  switch --flake .#my@linux --impure

# 2回目以降
nix run home-manager/master -- switch --flake .#my@linux --impure
```

**mac**

```sh
sudo nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .#mac --impure
```

## Test

```sh
act -W .github/workflows/home-manager.yaml workflow_dispatch
```

## WSL

### Browser

- https://qiita.com/yasuflatland-lf/items/02f1323e44e1af9f81b6

```sh
sudo add-apt-repository ppa:wslutilities/wslu
sudo apt update
sudo apt install wslu
```

### CUDA+cuDNN

- https://docs.nvidia.com/cuda/wsl-user-guide/index.html#step-3-set-up-a-linux-development-environment

```sh
wget https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/cuda_12.4.1_550.54.15_linux.run
sudo sh cuda_12.4.1_550.54.15_linux.run
```

- https://developer.nvidia.com/cudnn-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local

```sh
wget https://developer.download.nvidia.com/compute/cudnn/9.0.0/local_installers/cudnn-local-repo-ubuntu2204-9.0.0_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2204-9.0.0_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-ubuntu2204-9.0.0/cudnn-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cudnn
```

## VSCode

- [settings.json](https://gist.github.com/RyushiAok/04a683e8d6817bdd2005e867bbd49039)
- [keybindings.json](https://gist.github.com/RyushiAok/744fa2368e22e974390dd59ff9494acf)
