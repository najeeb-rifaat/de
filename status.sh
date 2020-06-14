#!/bin/bash
# Screenshot: http://s.natalian.org/2013-08-17/dwm_status.png
# Network speed stuff stolen from http://linuxclues.blogspot.sg/2009/11/shell-script-show-network-speed.html

export CYCLE_DELAY=3

print_volume() {
  VOL=$(amixer get Master | tail -n1 | sed -r "s/.*\[(.*)%\].*/\1/")
  MUTE=$(amixer get Master | tail -n1 | awk '{print $6}')
  printf "%s" "$SEP1"
  if [ "$VOL" -eq 0 ] || [[ "$MUTE" == "[off]" ]]; then
      printf "🔇 0%%"
  elif [ "$VOL" -gt 0 ] && [ "$VOL" -le 33 ]; then
      printf "🔈 %s%%" "$VOL"
  elif [ "$VOL" -gt 33 ] && [ "$VOL" -le 66 ]; then
      printf "🔉 %s%%" "$VOL"
  else
      printf "🔊 %s%%" "$VOL"
  fi
  printf "%s\n"
}

print_wifi() {
  ip=$(ip route get 8.8.8.8 2>/dev/null|grep -Eo 'src [0-9.]+'|grep -Eo '[0-9.]+')
  if=$(ip route get 8.8.8.8 2>/dev/null| awk '{print $5}')
    while IFS=$': \t' read -r label value
    do
      case $label in SSID) SSID=$value
        ;;
      signal) SIGNAL=${value// /}
        ;;
    esac
  done < <(iw "$if" link)

  RESULT=$(echo "${SSID:0:10}" | tr -cd "[:alnum:]")
  echo "直 $RESULT $SIGNAL $ip"
}

print_mem(){
  memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 1024))
  printf " %.0fMB" "$memfree"
}

print_bat(){
    # Change BAT1 to whatever your battery is identified as. Typically BAT0 or BAT1
    CHARGE=$(cat /sys/class/power_supply/BAT0/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT0/status)

    if [ "$STATUS" = "Charging" ]; then
        printf " %s%% %s" "$CHARGE" "$STATUS"
    else
        printf " %s%% %s" "$CHARGE" "$STATUS"
    fi
}

print_date(){
  printf "📆 %s" "$(date "+%a %d-%m-%y %H:%M")"
}

print_xkb() {
  keyboard_layout=$(xkb-switch)
  keyboard_layout=${keyboard_layout:0:2}
  keyboard_caps=$(xset -q | grep '00: Caps Lock:' | cut -d':' -f3 | cut -d' ' -f4)
  if [ $keyboard_caps = "on" ]
  then
    printf " %s" "$keyboard_layout" | awk '{print toupper($0)}'
  else
    printf " $keyboard_layout"
  fi
}

print_xbacklight() {
  printf "💡 %.0f" "$(xbacklight)"
}

print_cpu() {
  printf " %.0fMHz" "$(lscpu | grep 'CPU MHz' | cut -d' ' -f27)"
}

while true
do
  xsetroot -name "$(print_mem)|$(print_cpu)|$(print_wifi)|$(print_xbacklight)|$(print_bat)|$(print_volume)|$(print_xkb)|$(print_date)"
  sleep $CYCLE_DELAY
done
