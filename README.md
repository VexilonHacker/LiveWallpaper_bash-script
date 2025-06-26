# LiveWallpaper Bash Script

A simple bash script to set live video wallpapers on your Linux desktop using `xwinwrap` and `mpv`.

---

## Features

- Launch video wallpapers (`.mp4`) as your desktop background.
- Supports specifying wallpaper files or directories.
- Interactive menu to choose wallpapers from a directory.
- Kill/stop live wallpaper processes via script options or menu.
- Verbose debug output option for troubleshooting.
- Automatically detects screen resolution.
- No hardcoded directories — customizable via command line arguments.

---

## Requirements

Make sure these tools are installed:

- `xwinwrap`
- `mpv`
- `xdpyinfo`

On Arch Linux, install them with:
```bash
paru -S shantz-xwinwrap-bzr mpv xorg-xdpyinfo
``` 

or from _[shantanugoel.com](https://shantanugoel.com/2008/09/03/shantz-xwinwrap/)_

---

## Usage

Run the script followed by optional flags:
```bash
./live-wallpaper.sh [options]`
```

### Options:

| Option           | Description                                     |
|------------------|------------------------------------------------|
| `-v`, `--verbose`| Enable verbose debug output                      |
| `-d`, `--directory DIR` | Specify directory containing wallpapers (default: current directory) |
| `-f`, `--file FILE` | Specify a single wallpaper file to launch directly |
| `-k`, `--kill`   | Kill all running live wallpaper processes (`xwinwrap` and `mpv`) |
| `-h`, `--help`   | Show this help message and exit                  |

---

## Examples

- Launch interactive wallpaper chooser from default directory:

```bash
./live-wallpaper.sh
```

- Launch wallpaper chooser from a specific directory:


```bash
./live-wallpaper.sh -d wallpapers/
```


- Launch a specific wallpaper file directly:

```bash
./live-wallpaper.sh -f Wallpapers/astronaut.mp4
```


- Kill any running live wallpapers:


```bash
./live-wallpaper.sh --Kill
```


- Enable verbose debug output:

```bash
./live-wallpaper.sh -v -d Wallpapers
```


---

## How it works

- Detects your screen resolution with `xdpyinfo`.
- Uses `xwinwrap` to create a window pinned to the desktop background.
- `mpv` plays the specified video inside this window, looping silently without controls.
- You can pick wallpapers interactively or specify directly.
- Use the kill option or menu to stop live wallpapers.

---

## Troubleshooting

- Ensure `xwinwrap`, `mpv`, and `xdpyinfo` are installed and working.
- Verify wallpaper file paths are correct and accessible.
- If wallpapers don’t appear, check for errors related to `xwinwrap` or `mpv`.
- Use the `--verbose` flag to enable debug output and diagnose issues.

---

## License

This project is provided as-is under the MIT License. 

---


Enjoy your dynamic desktop wallpapers! 🎥🌌

