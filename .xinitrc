# load xresources
[[ -f $HOME/.Xresources ]] && exec xrdb -merge -I$HOME ~/.Xresources &

# set gtk theme
gsettings set org.gnome.desktop.interface gtk-theme Arc-Dark &

# load xmodmap
[[ -f $HOME/.Xmodmap ]] && exec xmodmap ~/.Xmodmap &

# bind shortcut keys (volume and brightness controls)
[[ -f $HOME/.xbindkeysrc ]] && xbindkeys &

# set wallpaper
[[ -f $HOME/Pictures/system/wallpaper.jpg ]] && feh --bg-center --image-bg "#11111b" $HOME/Pictures/system/wallpaper.jpg && wal -i $HOME/Pictures/system/wallpaper.jpg &

# set display variable for systemd
exec dbus-update-activation-environment --systemd DISPLAY &

# start status bar setter
exec $HOME/.local/bin/status_bar &

# set key repeat intensity
exec xset r rate 350 25 &

# bind shortcut keys (volume and brightness controls)
exec killall -q xbindkeys &
exec $(sleep 10 && xbindkeys) &

# start redshift for (Might not be working)
exec killall -q redshift &
exec redshift &

# start clipmenu
exec killall -q clipmenu &
exec clipmenud &

# start synergy after 0.2 seconds (allow x org to start)
exec $(killall -q synergys) &
exec $(sleep 1 && synergys -c $HOME/.config/synergy.conf) &

# DISABLED! start composition manager (PICOM)
#exec xcompmgr -CcfF -I-.02 -O-.02 -D2 -t-1 -l-3 -r4 -o.4 &
#exec picom --vsync --sw-opti --vsync-use-glfinish --backend xr_glx_hybrid --focus-exclude "x = 0 && y = 0 && override_redirect = true" &
exec picom -b --config $HOME/.config/picom/picom.conf --experimental-backends &

# start gestures
exec libinput-gestures-setup start &

# system video resolution and
exec $(sleep 0.2 && autorandr $(autorandr --detected) && wallpaper) &

# start ssh agent
exec eval $(ssh-agent) &

# start window manager (DWM)
exec dwm
