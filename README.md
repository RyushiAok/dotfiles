# dotfiles

## Setup

```sh
nix run home-manager/master -- switch --extra-experimental-features "nix-command flakes" --flake .#minimal@linux --impure
nix --extra-experimental-features "nix-command flakes" run nix-darwin -- switch --flake .#mac --impure
```

## WSL Ubuntu

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

### NeoVim

#### Python

https://neovim.io/doc/user/provider.html

```sh
pyenv install 3.12.2
pyenv virtualenv 3.12.2 py3nvim
pyenv activate py3nvim
python3 -m pip install pynvim
```

## VSCode

- [settings.json](https://gist.github.com/RyushiAok/04a683e8d6817bdd2005e867bbd49039)
- [keybindings.json](https://gist.github.com/RyushiAok/744fa2368e22e974390dd59ff9494acf)
