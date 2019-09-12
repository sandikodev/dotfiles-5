#!/bin/bash
SONG="$(mpc current)"
ICON="$HOME/.config/awesome/icons/music.png"
notify-send "Now playing" "$SONG" -i "$ICON"
