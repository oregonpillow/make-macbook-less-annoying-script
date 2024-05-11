#!/bin/sh


# collect statuses
CLAMCLOSED=$(/usr/sbin/ioreg -r -k AppleClamshellState -d 4 | grep -q '"AppleClamshellState" = Yes' && echo "true" || echo "false")
BLUEOFF=$(/usr/sbin/system_profiler SPBluetoothDataType | grep -q "State: Off" && echo "true" || echo "false")
WIFIOFF=$(/usr/sbin/networksetup -getairportpower en0 | grep -q "Wi-Fi Power (en0): Off" && echo "true" || echo "false")
MUTED=$(/usr/bin/osascript -e "output muted of (get volume settings)")
SLEEPOFF=$(/usr/bin/pmset -g | grep "SleepDisabled" | grep -q -o -E '[1]' && echo "true" || echo "false")
POWERED=$(/usr/bin/pmset -g batt | head -n 1 | cut -c19- | rev | cut -c 2- | rev | grep -q "AC Power" && echo "true" || echo "false")

# disable sleep while on battery otherwise script will not run when lid closed
if [ $SLEEPOFF = "false" ] && [ $POWERED = "false" ]; then
  sudo /usr/bin/pmset -b disablesleep 1
fi

if [ $CLAMCLOSED = "true" ] && [ $POWERED = "false" ]; then

  # disable bluetooth
  if [ $BLUEOFF = "false" ]; then
    /opt/homebrew/bin/blueutil --power 0        
  fi

  # disable wifi
  if [ $WIFIOFF = "false" ]; then
    /usr/sbin/networksetup -setairportpower en0 off
  fi

  # mute sound
  if [ $MUTED = "false" ]; then
    /usr/bin/osascript -e "set volume with output muted"
  fi

  # re-enable sleep mode
  sudo /usr/bin/pmset -b disablesleep 0
  # sleep in clamshell
  sudo /usr/bin/pmset sleepnow > /dev/null

fi
