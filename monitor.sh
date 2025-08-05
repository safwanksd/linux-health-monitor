#!/bin/bash

# Change to the script's directory to ensure relative paths work
cd "$(dirname "$0")"

# A bash script to monitor server health and send alerts.

# --- LOAD CONFIGURATION ---
# Check if the confog file exists, otherwise exit.
if [ -f ./monitor.conf ]; then
	source ./monitor.conf
else 
	echo "ERROR: Configuration file 'monitor.conf' not found."
        exit 1	
fi

# --- Functions ---

# Function to get the current time-stamp
get_timestamp(){
	date "+%Y-%m-%d %H:%M:%S"
}

# Function to log messages
log_message(){
	local message="$1"
	echo "$(get_timestamp) - $message" >> "$LOG_FILE"
}


# Function to send an alert email
send_alert(){
	local priority="$1"
	local title="$2"
	local body="$3"

	# Send the notification to the ntfy.sh topic using curl
	curl -s \
	     -H "Title: $title" \
	     -H "Priority: $priority" \
	     -H "Tags: warning" \
	     -d "$body" \
	    "https://ntfy.sh/$NTFY_TOPIC" > /dev/null
       # Also log the alert
       log_message "ALERT SENT via ntfy: Title: $title - Details: $body"  	
}

# Function to check the disk usage
check_disk_usage(){
	log_message "Checking the disk usage..."
        # Get the usage percentage of the root partition ('/')
	local usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
	if [ $usage -gt "$DISK_USAGE_THRESHOLD" ]; then
		send_alert "urgent" "High Disk Usage" "Disk Usage on / is at ${usage}%"
	else 
		log_message "OK: Disk usage is ${usage}%"	
	fi
}

# Function to check the memory usage
check_memory_usage(){
	log_message "Checking memory usage...."
	local usage=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')

	if [ $usage -gt "$MEMORY_USAGE_THRESHOLD" ]; then  
		send_alert "High Memory Usage" "Memory usage is at ${usage}%, which exceeds the threshold of ${MEMORY_USAGE_THRESHOLD}%."
	else
		log_message "OK: Memory usage is at ${usage}%."

	fi
}

# Function to check CPU load
check_cpu_load(){
	log_message "Checking CPU Load..."
	local load=$(uptime | awk -F'load average: ' '{print $2}' | cut -d, -f1 | awk '{printf "%.0f", $1 * 100}')
	if [ $load -gt "$CPU_LOAD_THRESHOLD" ]; then
		send_alert "High CPU load" "CPU load (1-min average) is at ${load}%, which exceeds the threshold of ${CPU_LOAD_THRESHOLD}"
	else 
		log_message "OK: The CPU Load is ${load}%."
	fi
}


# --- Main Logic ---
log_message "---- Starting Server Health Check ----"

check_disk_usage
check_memory_usage
check_cpu_load

log_message "---- Server Health Check Finished ----"

