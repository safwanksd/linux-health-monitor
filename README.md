# Linux Server Health Monitor

![Bash Shell](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=white)
![OS](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

A comprehensive Bash script to automate server health monitoring (CPU, Memory, Disk), directly solving real-world challenges from my system administration experience. This project demonstrates proactive, automated operational management.

---

## The Problem

In any IT operations role, a significant amount of time is spent manually checking the health of servers. This is reactive, inefficient, and often means problems are only discovered after they've started causing issues. This script was built to solve that problem by providing a proactive, automated monitoring solution.

## Features

* **Proactive Monitoring:** Checks for CPU load, memory usage, and disk space against configurable thresholds.
* **External Configuration:** All settings (thresholds, notification topic) are managed in an easy-to-edit `monitor.conf` file.
* **Instant Push Notifications:** Sends immediate push notifications to a phone or browser via the free **`ntfy.sh`** service when any metric exceeds its configured threshold.
* **Persistent Logging:** All checks, results, and alerts are timestamped and recorded in a log file for historical analysis and auditing.
* **Automation-Ready:** Designed to be run automatically by a `cron` job for continuous, hands-off monitoring.

## How It Works

The script performs the following steps:
1.  Loads configuration from `monitor.conf`, including the secret `ntfy.sh` topic name.
2.  Checks CPU load, memory usage, and disk space one by one.
3.  For each check, it compares the current value against the threshold set in the config file.
4.  If a threshold is breached, it triggers the `send_alert` function, which uses `curl` to send a POST request with the alert details to the `ntfy.sh` service.
5.  All actions are logged with a timestamp to the specified log file.

## Setup & Usage

1.  **Clone the repository:**
    ```sh
    git clone [https://github.com/safwanksd/linux-health-monitor.git](https://github.com/safwanksd/linux-health-monitor.git)
    cd linux-health-monitor
    ```
2.  **Configure the monitor:**
    * Edit `monitor.conf` to set your desired thresholds and choose a unique, secret `NTFY_TOPIC` name.
3.  **Subscribe to notifications:**
    * Install the `ntfy` app on your phone or visit `https://ntfy.sh/YOUR_TOPIC_NAME` in a browser and click "Subscribe".
4.  **Make the script executable:**
    ```sh
    chmod +x monitor.sh
    ```
5.  **Run a manual test:**
    ```sh
    ./monitor.sh
    ```
6.  **Automate with Cron:**
    * Open your crontab with `crontab -e`.
    * Add a line to run the script on a schedule (e.g., every 15 minutes):
        ```crontab
        */15 * * * * /path/to/your/linux-health-monitor/monitor.sh
        ```

---
