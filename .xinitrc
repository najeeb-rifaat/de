[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

exec wal -i /var/wallpaper.jpg &
exec redshift &
exec xcompmgr -CcfF -I-.010 -O-.02 -D3 -t-1 -l-3 -r4.2 -o.5 &
dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
exec $HOME/.local/bin/status_bar &
exec xset r rate 300 35 &
exec dwm
