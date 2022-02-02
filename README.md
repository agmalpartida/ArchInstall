# Arch Installer Script

<img src="https://imgur.com/a/Adj2lFS" />

---
## Create Arch ISO or Use Image

Download ArchISO from <https://archlinux.org/download/> and put on a USB drive with [Etcher](https://www.balena.io/etcher/), [Ventoy](https://www.ventoy.net/en/index.html), or [Rufus](https://rufus.ie/en/)

## Boot Arch ISO

From initial Prompt type the following commands:

```
loadkeys es
pacman -Sy git
git clone https://github.com/agmalpartida/ArchInstall
cd ArchInstall
./archinstall.sh
```

mkdir .mpd .config/pulse

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

paru -Syy

scp -r dotfiles alberto@192.168.1.211:Git/
scp -r ansible/laptop-dev-ansible alberto@192.168.1.211:Git/ansible/
scp -r ansible/ansible-roles alberto@192.168.1.211:Git/ansible/
scp -r secrets-git alberto@192.168.1.211:Git/
ssh -l alberto 192.168.1.211


INSTALL NVM
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
nvm install node

sudo pacman -S pyenv
pyenv install 3.9.2
pyenv global 3.9.2

ansible-galaxy install -r requirements.yml
ansible-playbook arch.yml --tags "linux,packages"
ansible-playbook arch.yml --tags "linux,dotfiles"
ansible-playbook arch.yml --tags "linux,cron"


## Troubleshooting

__[Arch Linux Installation Guide](https://github.com/rickellis/Arch-Linux-Install-Guide)__

### No Wifi

You can check if the WiFi is blocked by running `rfkill list`.
If it says **Soft blocked: yes**, then run `rfkill unblock wifi`

After unblocking the WiFi, you can connect to it. Go through these 5 steps:

#1: Run `iwctl`

#2: Run `device list`, and find your device name.

#3: Run `station [device name] scan`

#4: Run `station [device name] get-networks`

#5: Find your network, and run `station [device name] connect [network name]`, enter your password and run `exit`. You can test if you have internet connection by running `ping google.com`, and then Press Ctrl and C to stop the ping test.

