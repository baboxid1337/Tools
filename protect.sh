#!/bin/sh

# === Protect.sh v3.1 - Baboxid1337 ===
# Kompatibel dengan bash, sh, dash

BACKUP_DIR="$HOME/.protected_files"
LOG_FILE="$HOME/.protect.log"

mkdir -p "$BACKUP_DIR"

log_action() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

proteksi_file() {
    echo -n "Masukkan path file: "
    read file
    if [ ! -f "$file" ]; then
        echo "[ERROR] File tidak ditemukan!"
        return
    fi
    cp "$file" "$BACKUP_DIR/"
    chmod 444 "$file"
    log_action "Proteksi file: $file"
    echo "[OK] File berhasil diproteksi: $file"
}

unlock_file() {
    echo -n "Masukkan path file: "
    read file
    if [ ! -f "$file" ]; then
        echo "[ERROR] File tidak ditemukan!"
        return
    fi
    chmod 644 "$file"
    log_action "Unlock file: $file"
    echo "[OK] File berhasil di-unlock: $file"
}

proteksi_folder() {
    echo -n "Masukkan path folder: "
    read folder
    if [ ! -d "$folder" ]; then
        echo "[ERROR] Folder tidak ditemukan!"
        return
    fi
    find "$folder" -type f -exec cp {} "$BACKUP_DIR/" \; -exec chmod 444 {} \;
    log_action "Proteksi folder: $folder"
    echo "[OK] Semua file di $folder berhasil diproteksi."
}

restore_file() {
    echo -n "Masukkan nama file yang mau direstore: "
    read filename
    if [ ! -f "$BACKUP_DIR/$filename" ]; then
        echo "[ERROR] File backup tidak ditemukan!"
        return
    fi
    echo -n "Masukkan path tujuan restore: "
    read target
    cp "$BACKUP_DIR/$filename" "$target"
    chmod 644 "$target/$filename"
    log_action "Restore file: $filename ke $target"
    echo "[OK] File $filename berhasil direstore ke $target"
}

list_protected() {
    echo "=== Daftar File yang Diproteksi ==="
    ls -l "$BACKUP_DIR"
}

while true; do
    echo ""
    echo "=== Protect.sh v3.1 - Baboxid1337 ==="
    echo "1. Proteksi file"
    echo "2. Unlock file"
    echo "3. Proteksi folder"
    echo "4. Restore file dari backup"
    echo "5. List file yang diproteksi"
    echo "6. Keluar"
    echo -n "Pilih menu: "
    read menu

    case $menu in
        1) proteksi_file ;;
        2) unlock_file ;;
        3) proteksi_folder ;;
        4) restore_file ;;
        5) list_protected ;;
        6) echo "Keluar..."; exit 0 ;;
        *) echo "[ERROR] Menu tidak valid!" ;;
    esac
done
