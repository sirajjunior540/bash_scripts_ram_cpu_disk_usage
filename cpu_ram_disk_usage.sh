#!/bin/bash

# Thresholds
DISK_THRESHOLD=80
CPU_THRESHOLD=50
RAM_THRESHOLD=50

# Check Disk Usage
DISK_USAGE=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
if [ $DISK_USAGE -gt $DISK_THRESHOLD ]; then
  notify-send "Disk Alert" "High disk usage detected: $DISK_USAGE%"
fi

# Check CPU and RAM Usage
CPU_USAGE=$(mpstat | awk 'NR>3 { print 100 - $13 }')
RAM_USAGE=$(free | awk '/^Mem:/ {print $3/$2 * 100}')

if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
  notify-send "CPU Alert" "High CPU usage detected: $CPU_USAGE%"
  # Get the PID of the highest CPU consuming process
  HIGH_CPU_PID=$(ps aux --sort=-%cpu | awk 'NR==2 {print $2}')
  # Kill the highest CPU consuming process
  kill -9 $HIGH_CPU_PID
  notify-send "Action Taken" "Killed process $HIGH_CPU_PID due to high CPU usage"
fi

if (( $(echo "$RAM_USAGE > $RAM_THRESHOLD" | bc -l) )); then
  notify-send "RAM Alert" "High RAM usage detected: $RAM_USAGE%"
  # Get the PID of the highest RAM consuming process
  HIGH_RAM_PID=$(ps aux --sort=-%mem | awk 'NR==2 {print $2}')
  # Kill the highest RAM consuming process
  kill -9 $HIGH_RAM_PID
  notify-send "Action Taken" "Killed process $HIGH_RAM_PID due to high RAM usage"
fi
