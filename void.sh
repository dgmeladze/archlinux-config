#!/bin/bash
set -e

# === 1. Обновление системы ===
echo "==> Updating XBPS..."
sudo xbps-install -uy xbps
sudo xbps-install -uy

# === 2. Подключение non-free репозитория ===
echo "==> Enabling non-free repo..."
sudo xbps-install -Rsy void-repo-nonfree

# === 3. Установка утилит и dev-пакетов ===
echo "==> Installing base packages..."
sudo xbps-install -y curl wget git xz unzip zip nano vim gptfdisk gparted xtools mtools mlocate \
  ntfs-3g fuse-exfat bash-completion linux-headers gtksourceview4 ffmpeg htop \
  autoconf automake bison m4 make libtool flex meson ninja optipng sassc \
  libwebkit2gtk41-devel libwebkit2gtk41 webkit2gtk webkit2gtk-devel \
  json-glib-devel json-glib go gcc pkg-config zsh efibootmgr \
  gvfs-smb samba gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-afc gvfs-afp \
  libfido2 ykclient libyubikey pam-u2f

# === 4. Установка GNOME и порталов ===
echo "==> Installing GNOME desktop..."
sudo xbps-install -y xorg gnome gdm
sudo xbps-install -Rsy xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs xdg-user-dirs-gtk xdg-utils
sudo xbps-install -y gnome-browser-connector

# === 5. Сеть, аудио, печать, Bluetooth ===
echo "==> Installing network/audio/bluetooth/cups..."
sudo xbps-install -y dbus elogind NetworkManager NetworkManager-openvpn NetworkManager-openconnect \
  NetworkManager-vpnc NetworkManager-l2tp pulseaudio pulseaudio-utils pulsemixer \
  alsa-plugins-pulseaudio bluez cups cups-pk-helper cups-filters foomatic-db \
  foomatic-db-engine gutenprint

# Добавление текущего пользователя в группу bluetooth
echo "==> Adding user to bluetooth group..."
sudo usermod -aG bluetooth $USER

# === 6. Энергосбережение и cron ===
echo "==> Installing cronie, chrony, tlp, powertop..."
sudo xbps-install -y cronie chrony tlp tlp-rdw powertop

# === 7. Шрифты ===
echo "==> Installing fonts..."
sudo xbps-install -Rsy noto-fonts-emoji noto-fonts-ttf noto-fonts-ttf-extra noto-fonts-cjk \
  font-liberation-ttf font-firacode font-fira-ttf font-awesome \
  dejavu-fonts-ttf font-hack-ttf fontmanager ttf-ubuntu-font-family

# === 8. AMD GPU драйверы ===
echo "==> Installing AMD GPU drivers..."
sudo xbps-install -y linux-firmware-amd mesa-dri vulkan-loader mesa-vulkan-radeon mesa-vaapi mesa-vdpau

# === 9. Установка часового пояса (замени на нужный регион) ===
echo "==> Setting timezone..."
sudo ln -sf /usr/share/zoneinfo/Europe/Tbilisi /etc/localtime

# === 10. Темы и иконки ===
echo "==> Installing icon and cursor themes..."
sudo xbps-install -y papirus-icon-theme breeze-cursors

# === 11. Flatpak ===
echo "==> Installing Flatpak..."
sudo xbps-install -Sy flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# === 12. Подсветка экрана (ноутбуки) ===
echo "==> Installing backlight service..."
git clone https://github.com/madand/runit-services.git
sudo cp -R ./runit-services/backlight /etc/sv/

# === 13. Активация сервисов ===
echo "==> Enabling runit services..."
for svc in gdm dbus elogind NetworkManager bluetoothd cupsd cronie chronyd tlp backlight; do
  sudo ln -sv /etc/sv/$svc /var/service || true
done

# === 14. Отключение конфликтующих сервисов ===
echo "==> Disabling conflicting services..."
sudo unlink /var/service/acpid || true
sudo unlink /var/service/dhcpcd || true

# === Готово ===
echo "✅ Installation complete. Please reboot your system."
