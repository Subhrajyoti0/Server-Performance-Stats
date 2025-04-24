#!/bin/bash

# Function to get CPU usage
get_cpu_usage() {
  cpu_idle=$(top -bn1 | grep "Cpu(s):" | awk '{print $8}')
  cpu_usage=$((100 - $(echo "$cpu_idle" | cut -d'.' -f1)))
  echo "Total CPU Usage: ${cpu_usage}%"
}

# Function to get memory usage
get_memory_usage() {
  total_mem=$(free -m | awk 'NR==2 {print $2}')
  used_mem=$(free -m | awk 'NR==2 {print $3}')
  free_mem=$(free -m | awk 'NR==2 {print $4}')
  used_percent=$((used_mem * 100 / total_mem))
  echo "Total Memory Usage: ${used_mem}MB Used / ${total_mem}MB Total (${used_percent}%)"
  echo "                  ${free_mem}MB Free"
}

# Function to get disk usage for root partition
get_disk_usage() {
  total_disk=$(df -h / | awk 'NR==2 {print $2}')
  used_disk=$(df -h / | awk 'NR==2 {print $3}')
  free_disk=$(df -h / | awk 'NR==2 {print $4}')
  used_percent=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
  echo "Total Disk Usage (/): ${used_disk} Used / ${total_disk} Total (${used_percent}%)"
  echo "                    ${free_disk} Free"
}

# Function to get top CPU consuming processes
get_top_cpu_processes() {
  echo "Top 5 Processes by CPU Usage:"
  top -bn1 | grep -E '^ *[0-9]+' | sort -nr -k9 | head -n 5 | awk '{printf "%-5s %-10s %s\n", $1, $9"%", $12}'
}

# Function to get top memory consuming processes
get_top_mem_processes() {
  echo "\nTop 5 Processes by Memory Usage:"
  top -bn1 | grep -E '^ *[0-9]+' | sort -nr -k6 | head -n 5 | awk '{printf "%-5s %-10s %s\n", $1, $6"K", $12}'
}

# --- Stretch Goal Functions ---

# Function to get OS version
get_os_version() {
  os_info=$(cat /etc/*release | grep -E '^(NAME|VERSION)=' | sed 's/=".*"//' | paste -sd ' ')
  echo "\nOS Version: $os_info"
}

# Function to get uptime
get_uptime() {
  uptime_info=$(uptime | awk '{print $3, $4}')
  echo "Uptime: $uptime_info"
}

# Function to get load average
get_load_average() {
  load_avg=$(uptime | awk '{for (i=NF-2; i<=NF; i++) print $i}')
  echo "Load Average (1min, 5min, 15min): $load_avg"
}

# Function to get logged in users
get_logged_in_users() {
  users=$(who | wc -l)
  echo "Logged In Users: $users"
}

# Function to get failed login attempts (requires checking auth logs, may need sudo)
get_failed_logins() {
  failed=$(grep "Failed password" /var/log/auth.log* 2>/dev/null | wc -l)
  echo "Failed Login Attempts (last few logs): $failed"
}

# --- Main Script ---

echo "--- Server Performance Stats ---"
echo

get_cpu_usage
get_memory_usage
get_disk_usage
get_top_cpu_processes
get_top_mem_processes

echo
echo "--- Optional Stats ---"
echo

get_os_version
get_uptime
get_load_average
get_logged_in_users
# get_failed_logins # Uncomment this line if you want to check failed logins (may require sudo)

echo
echo "--- End of Stats ---"
