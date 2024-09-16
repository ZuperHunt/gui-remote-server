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
  sudo -i -u crd bash -c "sudo wget -O /home/crd/google-crd.deb https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb"
  sudo -i -u crd bash -c "sudo apt update && sudo apt upgrade -y"
  sudo -i -u crd bash -c "sudo dpkg --install /home/crd/google-crd.deb"
  sudo -i -u crd bash -c "sudo apt install --assume-yes --fix-broken"
  sudo -i -u crd bash -c "sudo DEBIAN_FRONTEND=noninteractive apt install --assume-yes xfce4 desktop-base"
  sudo bash -c "echo 'exec /etc/X11/Xsession /usr/bin/xfce4-session' > /etc/chrome-remote-desktop-session"
  sudo -i -u crd bash -c "sudo apt install --assume-yes xscreensaver"
  sudo -i -u crd bash -c "sudo systemctl disable lightdm.service"
  sudo -i -u crd bash -c "sudo wget -O /home/crd/google-chrome-web.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  sudo -i -u crd bash -c "sudo dpkg --install /home/crd/google-chrome-web.deb"
  sudo -i -u crd bash -c "sudo apt install --assume-yes --fix-broken"
}

# Starting message
echo -e "${BOLD}${UNDERLINE}Starting the script...${RESET}"
sleep 5

# Check if the script is running as root
if groups $USER | grep &>/dev/null '\bsudo\b'; then
    echo "Root user detected."
    sleep 5
    execute_with_prompt "adduser crd"
    execute_with_prompt "usermod -aG sudo crd"
    remote_desktop
    execute_with_prompt "su - crd"
else
    echo "User is not root. move to root with this command: su root"
    exit 1
fi