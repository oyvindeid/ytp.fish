# ytp.fish
A Fish shell script that lets you open clipboarded URLs to YouTube videos in [mpv](https://mpv.io) media player, using applied CLI options and/or config variables.

# Requirements
- [Fish](https://fishshell.com)
- [mpv](https://mpv.io)
- [youtube-dl](https://github.com/ytdl-org/youtube-dl)
- [GNU grep](https://www.gnu.org/software/grep)
- [GNU date](https://www.gnu.org/software/coreutils)
- [Perl 5](https://www.perl.org)
- macOS+pbpaste or a UNIX/Linux distribution with X11+[xclip](https://github.com/astrand/xclip) or Wayland+[wl-clipboard](https://github.com/bugaevc/wl-clipboard)

## Install
Copy the script to Fish's 'functions' directory

```sh
cp ytp.fish ~/.config/fish/functions
```

## Usage

```sh
ytp [OPTIONS] YOUTUBE-VIDEO-URL-FROM-CLIPBOARD
ytp --help
```

## Examples
(1) High/720p quality, french subs and logging

```sh
ytp --quality high --subs fr --autosubs no --logging yes
```

(2) Change defaults (in *~/.config/fish/config.fish*)

```sh
set -x ytp_quality low              # low mid high highest (360/480/720/1080p)
set -x ytp_subs fr,en,de
set -x ytp_autosubs yes
set -x ytp_logging yes              # add entries to ~/tubslog.txt
```

(3) Available subtitles for a movie

```sh
ytp --see-subs                      # non-automatic
ytp --see-auto-subs                 # auto-generated
ytp --see-trans-subs                # translated from a-g
ytp --see-all-subs                  # all the above
ytp --see-subs-matching fr,de,en    # german, french, and english subs
```

(4) Authentication using Brave browser cookies and 'basictext' keyring method

```sh
ytp --cookies yes --browser brave --keyring basictext
```

(5) Fast software decoding using 'mpv' config profile, 1080p quality, high quality codecs, fullscreen viewing

```sh
ytp --profile sw-fast --quality highest --hq-codecs yes --fullscreen yes
```

(6) Video filters

```sh
ytp --quality low --vf 'scale=w=2*iw:h=2*ih'        # scale 360p * 2
ytp --quality highest --vf 'scale=w=iw/2:h=ih/2'    # scale 1080p * 1/2
```

(7) Default and extra video filters

```sh
set -x ytp_vf 'scale=w=2*iw:h=2*ih'
ytp --quality mid --vf-extra 'eq=brightness=0.1:contrast=1.2:saturation=0.75'
```

(8) Save stream to file (note: filters and hardware decoding should not be used)

```sh
ytp --save-as 'NeilBreenEatsCannedTuna.mkv' --hwdec no --vf none --af none
```

## Maintainers

[@oyvindeid](https://github.com/oyvindeid)


## License

Simplified BSD License (BSD-2-Clause) © 2025 Øyvind Eidhammer
