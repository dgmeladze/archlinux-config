#!/bin/bash

# Exit on error
set -e

# Update system
sudo zypper refresh
sudo zypper --non-interactive update

# Install requested packages
sudo zypper --non-interactive install git wget curl steam filezilla zsh

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" --unattended
fi

# Install zsh-syntax-highlighting and zsh-autosuggestions
sudo zypper --non-interactive install zsh-syntax-highlighting zsh-autosuggestions

# Import Google signing key
wget https://dl.google.com/linux/linux_signing_key.pub
sudo rpm --import linux_signing_key.pub
rm linux_signing_key.pub

# Set up Visual Studio Code repository and install
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/zypp/repos.d/vscode.repo > /dev/null
sudo zypper refresh
sudo zypper --non-interactive install code

# Install Sway and related packages to mimic Ubuntu Sway Remix
sudo zypper --non-interactive install sway waybar wofi thunar nwg-look nwg-panel nwg-drawer nwg-menu grim slurp wl-clipboard swaylock swayidle swaybg foot

# Configure Sway
mkdir -p ~/.config/sway
cat << 'EOF' > ~/.config/sway/config
# Sway configuration to mimic Ubuntu Sway Remix

# Set variables
set $mod Mod4
set $term foot
set $menu wofi --show drun

# Keybindings
bindsym $mod+Return exec $term
bindsym $mod+d exec $menu
bindsym $mod+Shift+q kill
bindsym $mod+Shift+e exec swaymsg exit

# Window management
focus_follows_mouse no
default_border pixel 2
default_floating_border pixel 2
gaps inner 5
gaps outer 5

# Input configuration
input * {
    xkb_layout us
    xkb_options ctrl:nocaps
}

# Output configuration
output * bg #2e3440 solid_color

# Theme settings
client.focused #81a1c1 #2e3440 #eceff4 #81a1c1 #2e3440
client.unfocused #4c566a #2e3440 #d8dee9 #4c566a #2e3440
client.urgent #bf616a #2e3440 #eceff4 #bf616a #2e3440

# Waybar
exec_always waybar

# Swayidle for lock screen
exec swayidle -w \
    timeout 300 'swaylock -f -c 2e3440' \
    before-sleep 'swaylock -f -c 2e3440'

# Background
exec_always swaybg -m fill -i /usr/share/backgrounds/sway/Sway_Wallpaper_Blue_1920x1080.png
EOF

# Configure Waybar
mkdir -p ~/.config/waybar
cat << 'EOF' > ~/.config/waybar/config
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "modules-left": ["sway/workspaces", "sway/mode"],
    "modules-center": ["clock"],
    "modules-right": ["pulseaudio", "network", "battery", "tray"],
    "sway/workspaces": {
        "disable-scroll": true,
        "all-outputs": true
    },
    "clock": {
        "format": "{:%Y-%m-%d %H:%M}"
    },
    "pulseaudio": {
        "format": "{volume}% {icon}",
        "format-muted": "Muted {icon}",
        "format-icons": {
            "default": ["🔈", "🔉", "🔊"]
        }
    },
    "network": {
        "format-wifi": "{essid} ({signalStrength}%) 📶",
        "format-ethernet": "Ethernet 🖧",
        "format-disconnected": "Disconnected ⚠"
    },
    "battery": {
        "format": "{capacity}% {icon}",
        "format-icons": ["🔋", "🔋", "🔋", "🔋", "🔋"]
    }
}
EOF

cat << 'EOF' > ~/.config/waybar/style.css
* {
    font-family: sans-serif;
    font-size: 13px;
    color: #eceff4;
}

window#waybar {
    background: #2e3440;
    border-bottom: 2px solid #81a1c1;
}

#workspaces button {
    padding: 0 5px;
    background: transparent;
    color: #eceff4;
}

#workspaces button.focused {
    background: #81a1c1;
}

#clock, #pulseaudio, #network, #battery, #tray {
    padding: 0 10px;
}
EOF

# Install VLC and GIMP
sudo zypper --non-interactive install vlc gimp

# Set zsh as default shell
chsh -s /bin/zsh

echo "Setup complete! Please log out and log back in to use Sway and zsh."
