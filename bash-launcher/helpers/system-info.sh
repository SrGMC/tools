#!/bin/bash
#
# system-info-helper
# Script to display system info
#
# Author: Álvaro Galisteo (https://alvaro.ga)
# Copyright 2020 - GPLv3

upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
secs=$(("${upSeconds}"%60))
mins=$(("${upSeconds}"/60%60))
hours=$(("${upSeconds}"/3600%24))
days=$(("${upSeconds}"/86400))
UPTIME="$(printf "%d day(s), %d hours %d min. %d sec." "$days" "$hours" "$mins" "$secs")"
MEM_TOTAL=$(cat < /proc/meminfo | grep MemTotal | awk '{print $2}')
MEM_TOTAL=$((MEM_TOTAL/1024))
MEM_TOTAL=$((MEM_TOTAL/1024))
OS_VERSION="$(lsb_release -d | cut -f 2)"
CPU=$(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)
CORES="$(lscpu | grep 'CPU(s)' | head -1 | awk -F: '{print $2}' | xargs)"
BASE_FREQ="$(lscpu | grep 'CPU max MHz' | awk -F: '{print $2}' | xargs)"
VGA="$(lspci | grep VGA | awk -F: '{print $3}' | xargs)"

echo   "$(tput bold)Uptime:$(tput sgr0)              ${UPTIME}"
echo   "$(tput bold)Date:$(tput sgr0)                $(date +"%A, %e %B %Y, %R (%Z)")"
echo   "$(tput bold)OS:$(tput sgr0)                  ${OS_VERSION} $(uname -m)"
echo   "    Kernel:          $(uname -r)"
echo   "$(tput bold)Hardware:$(tput sgr0)"
echo   "    CPU:             ${CPU}"
echo   "    Cores:           ${CORES}"
printf "    Base frequency:  %.1fMHz\n" "$BASE_FREQ"
echo   "    RAM:             ${MEM_TOTAL}GB"
echo   "    Graphics card:   ${VGA}"
echo   "$(tput bold)Disks:$(tput sgr0)"
df -H


