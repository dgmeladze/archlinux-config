# 🚀 archlinux-config

This is my personal **Arch Linux post-installation setup script**, designed to automate and simplify the initial configuration process after a fresh Arch install.

---

## 🔧 What It Does

- Enables the `multilib` repository for 32-bit application support  
- Installs essential packages:  
  `steam`, `yay`, `git`, `wget`, `curl`, `filezilla`  
- Installs AUR packages using `yay`:  
  - `visual-studio-code-bin`  
  - `google-chrome`  
  - **Yaru Theme** (GNOME only): icons, GTK, shell, sounds  
- Sets up the Zsh shell:  
  - Installs **Oh My Zsh**  
  - Adds plugins: `zsh-syntax-highlighting`, `zsh-autosuggestions`  
  - Sets Zsh as the default shell  
- Installs **Telegram Desktop** directly from the official website

> **Note:** Telegram must be launched manually from `/opt` after installation to work correctly.

---

## ⚙️ How to Use

### ✅ One-liner (Recommended):

Run the script directly from GitHub:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/dgmeladze/archlinux-config/main/arch-setup.sh)"
```````

or via git clone 

```bash
git clone https://github.com/dgmeladze/archlinux-config.git
cd archlinux-config
sh arch-setup.sh
```````
