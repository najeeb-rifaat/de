yay -S --noconfirm nerd-fonts-roboto-mono ttf-nerd-fonts-symbols ttf-symbola-free

echo ">>>> Installing fonts"
cp -rf ./*.otf ~/.fonts/
cp -rf ./*.conf ~/.config/fontconfig/
fc-cache -f
