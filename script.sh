#!/bin/bash

# Colors for the terminal
BOLD="\033[1m"
UNDERLINE="\033[4m"
DARK_YELLOW="\033[0;33m"
CYAN="\033[0;36m"
RESET="\033[0;32m"

# Function to execute a command with a prompt
execute_with_prompt() {
    echo -e "${BOLD}Executing: $1${RESET}"
    if eval "$1"; then
        echo "Command executed successfully."
    else
        echo -e "${BOLD}${DARK_YELLOW}Error executing command: $1${RESET}"
        exit 1
    fi
}

# Function to deploy GUI chrome remote desktop
remote_desktop() {
  # Install the dependencies
  execute_with_prompt "sudo wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb"
  execute_with_prompt "sudo apt update && sudo apt upgrade -y"
  execute_with_prompt "sudo dpkg --install chrome-remote-desktop_current_amd64.deb -y"
  execute_with_prompt "sudo apt install --assume-yes --fix-broken"
  execute_with_prompt "sudo DEBIAN_FRONTEND=noninteractive apt install --assume-yes xfce4 desktop-base"
  sudo bash -c "echo 'exec /etc/X11/Xsession /usr/bin/xfce4-session' > /etc/chrome-remote-desktop-session"
  execute_with_prompt "sudo apt install --assume-yes xscreensaver"
  execute_with_prompt "sudo systemctl disable lightdm.service"
  execute_with_prompt "sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  execute_with_prompt "sudo dpkg --install google-chrome-stable_current_amd64.deb"
  execute_with_prompt "sudo apt install --assume-yes --fix-broken"
}

# Starting message
echo -e "${BOLD}${UNDERLINE}Starting the script...${RESET}"
wait 5

# Check if the script is running as root
if [ "$UID" -eq 0 ]; then
    echo "Script running as root."
    wait 5
    execute_with_prompt "sudo adduser crd"
    execute_with_prompt "sudo usermod -aG sudo crd"
    execute_with_prompt "sudo su - crd"
    execute_with_prompt "cd"
    remote_desktop
else
    echo "Script running as user."
    wait 5
    execute_with_prompt "cd"
    remote_desktop
fi