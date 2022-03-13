# Clipper

Clipper aims to make it easy to grab a small part from a video into a new file, all from within mpv.
It supports Linux but may not work with other operating systems yet.

## Usage
Pressing `g` shows the times when the current subtitle on screen will start and end.
Pressing `G` will render to a file the part of the video that the current subtitle on the screen corresponds to.

## Features
### Current
- Render clip containing current subtitle line to a file

### To Add
- Manually select times to render between
- Allow selecting multiple subtitle lines
- Output audio track should match the currently selected one

### In the Future
- Select file extension for the clip
- Configurable export quality


## Installation
### Script Directory
Linux: `~/.config/mpv/scripts`

### Method 1
Download the raw file `clipper.lua` and place it into the script directory.

### Method 2
Clone this repository and symlink `clipper.lua` into the script directory.

