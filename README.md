# Clamshell Connectivity Crusher

Crush wireless connectivity when Macbook enters clamshell mode.

## What the script does

When the Macbook is in clamshell mode + battery powered:

- turns off wifi adaptor
- turns off bluetooth adaptor
- Mutes the volume
- Forces sleep mode

When the Macbook exits clamshell mode, it does **NOT** re-enable wireless connectivity or un-mute the volume. This is by design.

## How to install

- `brew install blueutil`
- Make the script executable `chmod +x clamshell.sh`
- Create a crontab entry using `crontab -e` --> 
```
* * * * * <path to clamshell.sh>
```
## Motivation

- Prevent sounds whenever I open my macbook in a meeting
- Prevent wireless communications when I'm not actively using macbook

## Things to be aware of

- When you're on battery, the only way to make the macbook sleep will be to close the lid

## Reset Mac to default settings

If you decide to stop running the script, running `/usr/bin/pmset restoreDefaults` is a good way to ensure sleep settings are back to default.

## Improvement Ideas

- I think there might be a way to create hooks for sleep events, which would be better to avoid using crontab
- I would prefer to avoid using `blueutil` as a dependency, but didn't find a way to set bluetooth power state without this
- I've heard of `sleepwatcher`, available through brew as an alternative way to run hooks on sleep status, but again, I would like to avoid external dependencies
