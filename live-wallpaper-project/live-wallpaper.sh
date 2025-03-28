#!/bin/bash

# Directory containing the video files
VIDEO_DIR="$HOME/Videos/Wallpapers/"

# File containing ASCII art
LOGO_FILE="$HOME/.Projects/bash/live-wallpaper-project/logo"

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m' # Reset to default color

# Function to display the logo
display_logo() {
  cat "$LOGO_FILE"
}

# Function to choose a live wallpaper
choose_wallpaper() {
  echo -e "${CYAN}Choose a live wallpaper:${RESET}"
  select FILE_NAME in *.mp4 "Kill Background Wallpaper" "Exit"; do
    case "$FILE_NAME" in
      "Exit")
        echo -e "${RED}Exiting...${RESET}"
        exit 0
        ;;
      "Kill Background Wallpaper")
        echo -e "${YELLOW}Stopping Background Live Wallpaper${RESET}"
        killall xwinwrap 2>/dev/null
        ;;
      *)
        selected_wallpaper="$FILE_NAME"
        break
        ;;
    esac
  done
}

# Function to launch xwinwrap with mpv
launch_xwinwrap() {
  killall xwinwrap 2>/dev/null
  nohup xwinwrap -g 1920x1080+0+0 -ovr -ni -- mpv --fullscreen --no-stop-screensaver --loop --no-audio --no-border --no-osc --no-osd-bar --no-input-default-bindings -wid WID "$selected_wallpaper" > /dev/null 2>&1 &
  printf "\ec"
}

# Signal handler to catch SIGINT and exit cleanly
trap 'echo -e "\n${MAGENTA}Killing Live Wallpaper And Exiting...${RESET}"; exit 0' SIGINT

# Main function
main() {
  cd "$VIDEO_DIR" || { echo -e "${RED}Error: Unable to change directory to $VIDEO_DIR${RESET}"; exit 1; }
  while true; do
    display_logo
    choose_wallpaper
    launch_xwinwrap
  done
}

main


