# ytp.fish
A Fish shell script that lets you open clipboarded URLs to YouTube videos in [mpv](https://mpv.io) media player, using applied CLI options and/or config variables.

# Requirements
- [fish](https://fishshell.com)
- [mpv](https://mpv.io)
- [youtube-dl](https://github.com/ytdl-org/youtube-dl)
- [GNU grep](https://www.gnu.org/software/grep)
- [GNU date](https://www.gnu.org/software/coreutils)
- [Perl 5](https://www.perl.org)
- macOS+pbpaste or an UNIX/Linux distribution with X11+[xclip](https://github.com/astrand/xclip) or Wayland+[wl-clipboard](https://github.com/bugaevc/wl-clipboard)

## Install
Copy the script to the 'functions' directory of Fish's config directory

```sh
cp ytp.fish ~/.config/fish/functions
```

## Usage

```sh
ytp --help
```

## Maintainers

[@oyvindeid](https://github.com/oyvindeid)


## License
Simplified BSD License (BSD-2-Clause) © 2025 Øyvind Eidhammer
