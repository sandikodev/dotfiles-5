#!/usr/bin/env bash
# This script executes each time restarting awesome. Function 'run' checks is program already running
# to avoid starting few instances of one program

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

run compton
run redshift

# Keyboard layout
setxkbmap -layout "us,ru,ua" -option "grp:alt_shift_toggle"
