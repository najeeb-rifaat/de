yay -S --noconfirm ttf-nerd-fonts-symbols ttf-devicons ttf-symbola-free

echo ">>>> Installing fonts"
cp -rf ./*.otf ~/.fonts/
cp -rf ./*.conf ~/.config/fontconfig/
fc-cache -f
