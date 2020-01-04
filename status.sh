#!/bin/bash
# Screenshot: http://s.natalian.org/2013-08-17/dwm_status.png
# Network speed stuff stolen from http://linuxclues.blogspot.sg/2009/11/shell-script-show-network-speed.html

# This function parses /proc/net/dev file searching for a line containing $interface data.
# Within that line, the first and ninth numbers after ':' are respectively the received and transmited bytes.
function get_bytes {
  # Find active network interface
  interface=$(ip route get 8.8.8.8 2>/dev/null| awk '{print $5}')
  line=$(grep $interface /proc/net/dev | cut -d ':' -f 2 | awk '{print "received_bytes="$1, "transmitted_bytes="$9}')
  eval $line
  now=$(date +%s%N)
}

# Function which calculates the speed using actual and old byte number.
# Speed is shown in KByte per second when greater or equal than 1 KByte per second.
# This function should be called each second.

function get_velocity {
  value=$1
  old_value=$2
  now=$3

  timediff=$(($now - $old_time))
  velKB=$(echo "1000000000*($value-$old_value)/1024/$timediff" | bc)
  if test "$velKB" -gt 1024
  then
    echo $(echo "scale=2; $velKB/1024" | bc)MB/s
  else
    echo ${velKB}KB/s
  fi
}

# Get initial values
get_bytes
old_received_bytes=$received_bytes
old_transmitted_bytes=$transmitted_bytes
old_time=$now

print_volume() {
  volume="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"
  if test "$volume" -gt 0
  then
    echo -e "${volume}"
  else
    echo -e "Mute"
  fi
}

print_wifi() {
  ip=$(ip route get 8.8.8.8 2>/dev/null|grep -Eo 'src [0-9.]+'|grep -Eo '[0-9.]+')
  if=$(ip route get 8.8.8.8 2>/dev/null| awk '{print $5}')
    while IFS=$': \t' read -r label value
    do
      case $label in SSID) SSID=$value
        ;;
      signal) SIGNAL=$value
        ;;
    esac
  done < <(iw "$if" link)

  RESULT=$(echo "${SSID:0:10}" | tr -cd "[:alnum:]")
  echo "$RESULT $SIGNAL $ip"
}

print_mem(){
  memfree=$(($(grep -m1 'MemAvailable:' /proc/meminfo | awk '{print $2}') / 1024))
  echo -e "${memfree}MB"
}

print_bat(){
  hash acpi || return 0
  onl="$(grep "on-line" <(acpi -V))"
  charge="$(awk '{ sum += $1 } END { print sum }' /sys/class/power_supply/BAT*/capacity)"
  if test -z "$onl"
  then
    # suspend when we close the lid
    #systemctl --user stop inhibit-lid-sleep-on-battery.service
    echo -e "${charge}"
  else
    # On mains! no need to suspend
    #systemctl --user start inhibit-lid-sleep-on-battery.service
    echo -e "${charge}"
  fi
}

print_date(){
  date "+%a %m-%d %H:%M%p"
}

print_xkb() {
  keyboard_layout=$(xkb-switch)
  keyboard_layout=${keyboard_layout:0:2}
  keyboard_layout=$(echo $keyboard_layout | awk '{print toupper($0)}')
  keyboard_caps=$(xset -q | grep '00: Caps Lock:' | cut -d':' -f3 | cut -d' ' -f4)
  if [ $keyboard_caps = "on" ]
  then
    echo "$keyboard_layout "
  else
    echo "$keyboard_layout"
  fi
}

print_xbacklight() {
  backight=$(xbacklight | cut -d"." -f1)
  echo "$backight"
}

while true
do

  # Get new transmitted, received byte number values and current time
  get_bytes

  # Calculates speeds
  vel_recv=$(get_velocity $received_bytes $old_received_bytes $now)
  vel_trans=$(get_velocity $transmitted_bytes $old_transmitted_bytes $now)

  xsetroot -name "$vel_recv $vel_trans $(print_mem) $(print_wifi) B:$(print_bat) V:$(print_volume) $(print_date) $(print_xkb)"

  # Update old values to perform new calculations
  old_received_bytes=$received_bytes
  old_transmitted_bytes=$transmitted_bytes
  old_time=$now

  sleep 1

done
