# load xresources
[[ -f $HOME/.Xresources ]] && exec xrdb -merge -I$HOME ~/.Xresources &

# load xmodmap
[[ -f $HOME/.Xmodmap ]] && exec xmodmap ~/.Xmodmap &

# bind shortcut keys (volume and brightness controls)
[[ -f $HOME/.xbindkeysrc ]] && xbindkeys &

# set wallpaper
[[ -f $HOME/Pictures/system/wallpaper.jpg ]] && feh --bg-fill $HOME/Pictures/system/wallpaper.jpg &

# set display variable for systemd
exec dbus-update-activation-environment --systemd DISPLAY &

# start status bar setter
exec $HOME/.local/bin/status_bar &

# set key repeat intensity
exec xset r rate 350 25 &

# bind shortcut keys (volume and brightness controls)
exec xbindkeys &

# start redshift for (Might not be working)
exec redshift &

# start composition manager
exec xcompmgr -CcfF -I-.010 -O-.02 -D3 -t-1 -l-3 -r4.2 -o.5 &

# start clipmenu
exec clipmenud &

# start window manager (DWM)
exec dwm

