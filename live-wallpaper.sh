#!/bin/bash

VERBOSE=false
VIDEO_DIR="."
selected_wallpaper=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

usage() {
    cat <<EOF
    Usage: $0 [options]

    Options:
    -v, --verbose            Enable verbose debug output
    -d, --directory DIR      Specify directory containing wallpapers (default: current directory)
    -f, --file FILE          Specify a single wallpaper file to launch directly
    -k, --kill               Kill all running live wallpaper processes (xwinwrap and mpv)
    -h, --help               Show this help message and exit

    If no file is specified, a menu will be shown to pick from the directory wallpapers.
EOF
}

check_dependencies() {
    for cmd in xwinwrap mpv xdpyinfo; do
        if ! command -v "$cmd" &>/dev/null; then
            echo -e "${RED}Error: '$cmd' is not installed. Please install it before running this script.${RESET}"
            exit 1
        fi
    done
}

log() {
    if $VERBOSE; then
        echo -e "${MAGENTA}[DEBUG]${RESET} $1"
    fi
}

display_logo() {
    cat <<'EOF'

        $$\       $$\                            $$\      $$\           $$\ $$\
        $$ |      \__|                           $$ | $\  $$ |          $$ |$$ |
        $$ |      $$\ $$\    $$\  $$$$$$\        $$ |$$$\ $$ | $$$$$$\  $$ |$$ | $$$$$$\   $$$$$$\   $$$$$$\   $$$$$$\   $$$$$$\
        $$ |      $$ |\$$\  $$  |$$  __$$\       $$ $$ $$\$$ | \____$$\ $$ |$$ |$$  __$$\  \____$$\ $$  __$$\ $$  __$$\ $$  __$$\
        $$ |      $$ | \$$\$$  / $$$$$$$$ |      $$$$  _$$$$ | $$$$$$$ |$$ |$$ |$$ /  $$ | $$$$$$$ |$$ /  $$ |$$$$$$$$ |$$ |  \__|
        $$ |      $$ |  \$$$  /  $$   ____|      $$$  / \$$$ |$$  __$$ |$$ |$$ |$$ |  $$ |$$  __$$ |$$ |  $$ |$$   ____|$$ |
        $$$$$$$$\ $$ |   \$  /   \$$$$$$$\       $$  /   \$$ |\$$$$$$$ |$$ |$$ |$$$$$$$  |\$$$$$$$ |$$$$$$$  |\$$$$$$$\ $$ |
        \________|\__|    \_/     \_______|      \__/     \__| \_______|\__|\__|$$  ____/  \_______|$$  ____/  \_______|\__|
                                                                                $$ |                $$ |
                                                                                $$ |                $$ |
                                                                                \__|                \__|
EOF
}

choose_wallpaper() {
    echo -e "${CYAN}Choose a live wallpaper:${RESET}"
    select FILE in *.mp4 "Kill Background Wallpaper" "Exit"; do
        case "$FILE" in
            Exit)
                echo -e "${RED}Exiting...${RESET}"
                exit 0
                ;;
            "Kill Background Wallpaper")
                echo -e "${YELLOW}Stopping Background Live Wallpaper${RESET}"
                killall xwinwrap 2>/dev/null
                ;;
            *)
                if [[ -f "$FILE" ]]; then
                    selected_wallpaper="$(realpath "$FILE")"
                    break
                else
                    echo -e "${RED}Invalid selection. Try again.${RESET}"
                fi
                ;;
        esac
    done
}


launch_xwinwrap() {
  resolution=$(xdpyinfo | awk '/dimensions:/ {print $2}')
  log "Detected screen resolution: $resolution"
  log "Selected wallpaper: $selected_wallpaper"
  killall xwinwrap 2>/dev/null
  echo -e "${GREEN}Launching wallpaper in background...${RESET}"
  # Launch in background and redirect output to /dev/null to keep terminal clean
  nohup xwinwrap -g "${resolution}+0+0" -ni -ov -- mpv -wid WID --loop --no-audio --no-border --no-osc --no-osd-bar --no-input-default-bindings "$selected_wallpaper" > /dev/null 2>&1 &
  rc=$?
  if [[ $rc -eq 0 ]]; then
    echo -e "${GREEN}Wallpaper launched successfully.${RESET}"
  else
    echo -e "${RED}Failed to launch wallpaper.${RESET}"
  fi
}


parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -d|--directory)
                if [[ -d "$2" ]]; then
                    VIDEO_DIR="$(realpath "$2")"

                    shift 2
                else
                    echo -e "${RED}Error: Directory '$2' does not exist.${RESET}"
                    exit 1
                fi
                ;;
            -f|--file)
                if [[ -f "$2" ]]; then
                    selected_wallpaper="$(realpath "$2")"
                    shift 2
                else
                    echo -e "${RED}Error: File '$2' does not exist.${RESET}"
                    exit 1
                fi
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -k|--kill)
                echo -e "${YELLOW}Killing all xwinwrap and mpv processes...${RESET}"
                killall xwinwrap mpv 2>/dev/null
            exit 0
            ;;

            *)
                echo -e "${RED}Unknown option: $1${RESET}"
                usage
                exit 1
                ;;
        esac
    done
}

trap 'echo -e "\n${RED}Interrupted. Killing xwinwrap...${RESET}"; killall xwinwrap; exit 1' SIGINT

main() {
    check_dependencies
    parse_args "$@"

    if [[ -n "$selected_wallpaper" ]]; then
        launch_xwinwrap
    else
        cd "$VIDEO_DIR" || { echo -e "${RED}Error: Unable to change directory to $VIDEO_DIR${RESET}"; exit 1; }
        display_logo
        choose_wallpaper
        launch_xwinwrap
    fi
}

main "$@"

