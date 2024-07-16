# System Resource Monitoring and Management Script

This repository contains a Bash script designed to monitor system resources (CPU, RAM, and Disk usage) on a Linux system. When resource usage exceeds specified thresholds, the script sends desktop notifications and takes action to manage the resources, such as terminating the highest resource-consuming processes.

## Features

- **Disk Usage Monitoring**: Alerts when disk usage exceeds a specified threshold.
- **CPU Usage Monitoring**: Alerts when CPU usage exceeds a specified threshold and kills the highest CPU-consuming process.
- **RAM Usage Monitoring**: Alerts when RAM usage exceeds a specified threshold and kills the highest RAM-consuming process.
- **Desktop Notifications**: Uses `notify-send` to send alerts and actions taken.

## Usage

1. **Clone the Repository**:

    ```sh
    git clone https://github.com/sirajjunior540/bash_scripts_ram_cpu_disk_usage.git
    cd bash_scripts_ram_cpu_disk_usage
    ```

2. **Make the Script Executable**:

    ```sh
    chmod +x cpu_ram_disk_usage.sh
    ```

3. **Run the Script**:

    ```sh
    ./cpu_ram_disk_usage.sh
    ```

4. **Schedule the Script with Cron**:
   
    To run the script every 5 minutes, add the following line to your crontab:
   
    ```sh
    crontab -e
    ```

    Add the following line:
   
    ```sh
    */5 * * * * /path/to/your/repo/cpu_ram_disk_usage.sh
    ```

    Replace `/path/to/your/repo/cpu_ram_disk_usage.sh` with the actual path to the script.

## Script Details

```bash
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
