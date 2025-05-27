#!/bin/sh


# collect statuses
CLAMCLOSED=$(/usr/sbin/ioreg -r -k AppleClamshellState -d 4 | grep -q '"AppleClamshellState" = Yes' && echo "true" || echo "false")
SLEEPOFF=$(/usr/bin/pmset -g | grep "SleepDisabled" | grep -q -o -E '[1]' && echo "true" || echo "false")
POWERED=$(/usr/bin/pmset -g batt | head -n 1 | cut -c19- | rev | cut -c 2- | rev | grep -q "AC Power" && echo "true" || echo "false")

if [ $SLEEPOFF = "false" ]; then
  sudo /usr/bin/pmset -b disablesleep 1
fi

if [ $CLAMCLOSED = "true" ] && [ $POWERED = "false" ]; then
  # mute sound
  /usr/bin/osascript -e "set volume with output muted"
  # disable bluetooth
  /opt/homebrew/bin/blueutil --power 0
  # disable wifi
  /usr/sbin/networksetup -setairportpower en0 off
  # diconnect wireguard if enabled
  /opt/homebrew/bin/wg-quick down home
  # enable sleep
  sudo /usr/bin/pmset -b disablesleep 0
  # force sleep
  sudo /usr/bin/pmset sleepnow > /dev/null
fi
