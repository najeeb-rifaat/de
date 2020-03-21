echo ">>> Installing dependencies"
sudo pacman -s --noconfirm git pv
sudo pacman -s --noconfirm python-pywal redshift xcompmgr
sudo pacman -S --noconfirm gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly
sudo pacman -S --noconfirm iw neovim python python-pip
sudo pacman -S --noconfirm mpv cb scrot imagemagic i3lock xbindkeys
sudo pacman -S --noconfirm clipmenu dunst
yay -S --noconfirm xkb-switch batify

echo ">>>> Installing images"
install -m755 -D ./wallpaper.jpg $HOME/Pictures/system/wallpaper.jpg

echo ">>>> Installing lockscreen"
sudo install -m644 -D ./sleeplock.service /etc/systemd/system/sleeplock.service
sudo systemctl daemon-reload
sudo systemctl enable sleeplock.service

echo ">>>> Installing scripts"
install -m755 -D ./lock.sh $HOME/.local/bin/lock
install -m755 -D ./clip.sh $HOME/.local/bin/clip
install -m755 -D ./shot.sh $HOME/.local/bin/shot
install -m755 -D ./xpass.sh $HOME/.local/bin/xpass
install -m755 -D ./status.sh $HOME/.local/bin/status_bar

echo ">>>> Installing Xorg settings"
sudo cp -rf ./xorg.conf.d/*.conf /etc/X11/xorg.conf.d/

echo ">>>> Setting wallpaper"
feh --bg-scale $HOME/Pictures/system/wallpaper.jpg

echo ">>>> Generating color schemes"
wal -i $HOME/Pictures/system/wallpaper.jpg
sed "17d" $HOME/.cache/wal/colors-wal-dwm.h > $HOME/.cache/wal/colors-wal-dwm.6.2.h

echo ">>>> Setting Xkeybind"
install -m755 -D ./.xbindkeysrc $HOME/.xbindkeysrc

echo ">>>> Setting Dunst (notifications)"
install -m755 -D ./dunstrc $HOME/.config/dunst/dunstrc

echo ">>>> Setting Xinit"
install -m755 -D ./.xinitrc $HOME/.xinitrc

echo ">>>> Installing DE modules"
git submodule foreach ./install.sh

echo ">>>> Fonts"
cd ./fonts && ./install.sh && cd ..
