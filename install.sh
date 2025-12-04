#!/bin/bash

echo "====== Installing Packages (Skipping non-existent ones) ======"

while read -r pkg; do
    if [[ -z "$pkg" ]]; then
        continue
    fi

    echo "▶ Installing: $pkg"
    if ! sudo pacman -S --needed --noconfirm "$pkg"; then
        echo "⚠️ Skipping non-existent or failed package: $pkg"
    fi
done < pkglist.txt


echo "====== Linking Configuration Files ======"

mkdir -p ~/.config

for dir in config/*; do
    name=$(basename "$dir")
    rm -rf ~/.config/$name
    ln -s "$(pwd)/config/$name" ~/.config/$name
    echo "✅ Linked ~/.config/$name"
done

for file in home/*; do
    name=$(basename "$file")
    rm -f ~/$name
    ln -s "$(pwd)/home/$name" ~/$name
    echo "✅ Linked ~/$name"
done

echo "====== Enabling Common Services ======"
systemctl --user enable --now fcitx5.service 2>/dev/null || true

echo "✅✅✅ All solvable content has been restored!"
echo "(Failed packages were automatically skipped and do not affect system usage)"
