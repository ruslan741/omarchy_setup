#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"
TS="$(date +%s)"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}==>${NC} $*"; }
warn() { echo -e "${YELLOW}!! ${NC}$*"; }

# install_dir <src> <dst> : copy files of a dir into destination, backing up existing
install_dir() {
    local src="$1" dst="$2"
    if [ ! -d "$src" ]; then
        warn "Пропускаю: исходный каталог не найден: $src"
        return
    fi
    mkdir -p "$dst"
    if [ -n "$(ls -A "$dst" 2>/dev/null)" ]; then
        local bak="${dst}.bak.${TS}"
        log "Бэкап: $dst -> $bak"
        cp -a "$dst" "$bak"
    fi
    log "Установка: $src/ -> $dst/"
    rsync -a "$src/" "$dst/"
}

# install_file <src> <dst> : copy a single file, backing up existing
install_file() {
    local src="$1" dst="$2"
    if [ ! -f "$src" ]; then
        warn "Пропускаю: исходный файл не найден: $src"
        return
    fi
    if [ -f "$dst" ]; then
        local bak="${dst}.bak.${TS}"
        log "Бэкап: $dst -> $bak"
        cp -a "$dst" "$bak"
    fi
    log "Установка: $src -> $dst"
    cp -a "$src" "$dst"
}

install_pkg() {
    local bin="$1" pkg="$2" helper="${3:-pacman}"
    if command -v "$bin" >/dev/null 2>&1; then
        warn "$pkg уже установлен"
        return
    fi
    if [ "$helper" = "pacman" ]; then
        log "Установка пакета: $pkg"
        sudo pacman -S --needed --noconfirm "$pkg"
    else
        log "Установка пакета: $pkg (AUR)"
        yay -S --needed --noconfirm "$pkg"
    fi
}

echo -e "${CYAN}=== Omarchy setup restore ===${NC}"

# --- 1. Пакеты (сначала) ---
echo -e "${CYAN}--- Пакеты ---${NC}"
install_pkg cava cava pacman
install_pkg durdraw durdraw yay
install_pkg curl curl pacman

if [ -d "$HOME_DIR/.oh-my-zsh" ]; then
    warn "oh-my-zsh уже установлен (~/.oh-my-zsh существует), пропускаю установку"
else
    log "Установка oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# --- 2. Файлы (потом) ---
echo -e "${CYAN}--- Каталоги конфигов в ~/.config ---${NC}"
install_dir "$SCRIPT_DIR/aether"      "$HOME_DIR/.config/aether"
install_dir "$SCRIPT_DIR/hypr"        "$HOME_DIR/.config/hypr"
install_dir "$SCRIPT_DIR/nvim"        "$HOME_DIR/.config/nvim"
install_dir "$SCRIPT_DIR/omarchy"     "$HOME_DIR/.config/omarchy"
install_dir "$SCRIPT_DIR/swayosd"     "$HOME_DIR/.config/swayosd"
install_dir "$SCRIPT_DIR/walker"      "$HOME_DIR/.config/walker"
install_dir "$SCRIPT_DIR/waybar"      "$HOME_DIR/.config/waybar"

echo -e "${CYAN}--- oh-my-zsh: plugins / themes / oh-my-zsh.sh ---${NC}"
install_dir  "$SCRIPT_DIR/oh-my-zsh/plugins"      "$HOME_DIR/.oh-my-zsh/plugins"
install_dir  "$SCRIPT_DIR/oh-my-zsh/themes"       "$HOME_DIR/.oh-my-zsh/themes"
install_file "$SCRIPT_DIR/oh-my-zsh/oh-my-zsh.sh" "$HOME_DIR/.oh-my-zsh/oh-my-zsh.sh"

echo -e "${CYAN}--- ~/.zshrc ---${NC}"
install_file "$SCRIPT_DIR/.zshrc"     "$HOME_DIR/.zshrc"

echo
echo -e "${GREEN}Готово. Если нужно применить изменения:${NC}"
echo "  hyprctl reload       # Hyprland"
echo "  omarchy restart waybar"
echo "  omarchy restart walker"