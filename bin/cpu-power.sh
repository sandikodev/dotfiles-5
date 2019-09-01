#!/bin/bash
# This script swtches cpu governor. Allow run cpufreq-set without password to use it.

get_current_governor() {
    cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
}

switch_governor() {
    if [[ "$1" == "powersave" ]]; then
        for (( i = 0; i < $(nproc); i++ )); do
          sudo cpufreq-set -c $i -g performance
        done
    elif [[ "$1" == "performance" ]]; then
        for (( i = 0; i < $(nproc); i++ )); do
          sudo cpufreq-set -c $i -g powersave
        done
    fi
    awesome-client "awesome.emit_signal(\"cpu::governor\", \"$(get_current_governor)\", false)"
}

current_governor="$(get_current_governor)"

if [[ "$1" = "--emit" ]]; then
    awesome-client "awesome.emit_signal(\"cpu::governor\", \"${current_governor}\", true)"
elif [[ "$1" = "--switch" ]]; then
    switch_governor $current_governor
fi
