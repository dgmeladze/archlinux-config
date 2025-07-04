#!/bin/bash

set -e

echo "==> Проверка и включение multilib при необходимости..."

if grep -q "^#\[multilib\]" /etc/pacman.conf; then
  echo "==> Включение [multilib] репозитория..."
  sudo sed -i '/^\#\[multilib\]/,/^\#Include = \/etc\/pacman\.d\/mirrorlist/ s/^#//' /etc/pacman.conf
else
  echo "==> multilib уже включён"
fi


echo "==> Обновление системы..."
sudo pacman -Syu --noconfirm

echo "==> Установка пакетов из официального репозитория..."
sudo pacman -S --noconfirm \
  git wget curl filezilla steam zsh

echo "==> Установка yay..."
sudo pacman -S --needed --noconfirm base-devel
if ! command -v yay >/dev/null 2>&1; then
  cd /tmp
  git clone https://aur.archlinux.org/yay.git
  cd yay
  makepkg -si --noconfirm
else
  echo "==> yay уже установлен"
fi

echo "==> Установка AUR пакетов (vscode, chrome, yaru)..."
yay -S --noconfirm \
  visual-studio-code-bin \
  google-chrome \
  yaru-gnome-shell-theme  \
  yaru-gtk-theme \
  yaru-icon-theme \
  yaru-sound-theme

echo "==> Установка Oh My Zsh..."
export RUNZSH=no
export CHSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

echo "==> Установка zsh-syntax-highlighting..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

echo "==> Установка zsh-autosuggestions..."
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

echo "==> Обновление ~/.zshrc для подключения плагинов..."
sed -i 's/^plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

echo "==> Назначение Zsh как оболочки по умолчанию..."
chsh -s "$(which zsh)"

echo "✅ Всё готово. Перезапустите терминал или выйдите-войдите, чтобы применить Zsh и тему."
