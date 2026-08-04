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

# install_dir <src> <dst> [--no-git] : copy files of a dir into destination, backing up existing
install_dir() {
    local src="$1" dst="$2" extra="${3:-}"
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
    if [ "$extra" = "--no-git" ]; then
        rsync -a --exclude='.git/' "$src/" "$dst/"
    else
        rsync -a "$src/" "$dst/"
    fi
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

echo -e "${CYAN}=== Omarchy setup restore ===${NC}"

# --- Каталоги конфигов в ~/.config ---
install_dir "$SCRIPT_DIR/aether"      "$HOME_DIR/.config/aether"
install_dir "$SCRIPT_DIR/hypr"        "$HOME_DIR/.config/hypr"
install_dir "$SCRIPT_DIR/nvim"        "$HOME_DIR/.config/nvim"
install_dir "$SCRIPT_DIR/omarchy"     "$HOME_DIR/.config/omarchy"
install_dir "$SCRIPT_DIR/swayosd"     "$HOME_DIR/.config/swayosd"
install_dir "$SCRIPT_DIR/walker"      "$HOME_DIR/.config/walker"
install_dir "$SCRIPT_DIR/waybar"      "$HOME_DIR/.config/waybar"

# --- oh-my-zsh (без вложенной git-истории) ---
install_dir "$SCRIPT_DIR/.oh-my-zsh"  "$HOME_DIR/.oh-my-zsh" --no-git

# --- ~/.zshrc ---
install_file "$SCRIPT_DIR/.zshrc"     "$HOME_DIR/.zshrc"

# --- Пакеты ---
echo
if ! command -v cava >/dev/null 2>&1; then
    log "Установка пакета: cava"
    sudo pacman -S --needed --noconfirm cava
else
    warn "cava уже установлен ($(pacman -Q cava))"
fi

if ! command -v durdraw >/dev/null 2>&1; then
    log "Установка пакета: durdraw (AUR)"
    yay -S --needed --noconfirm durdraw
else
    warn "durdraw уже установлен"
fi

echo
echo -e "${GREEN}Готово. Если нужно применить изменения:${NC}"
echo "  hyprctl reload       # Hyprland"
echo "  omarchy restart waybar"
echo "  omarchy restart walker"