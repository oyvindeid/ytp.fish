function ytp -d "Open a pasteboarded URL to a YouTube video in mpv player"

  set -g APP_NAME 'ytp'
  set -g APP_VERSION '0.1.0'
  set -g APP_REQUIREMENTS 'fish (4.0.2),mpv (0.33.1),youtube-dl (2025.06.09),GNU grep (3.12),perl (5.34.3),GNU date (from GNU coreutils 9.5),macOS+pbpaste or a UNIX/Linux distribution using either X11+xclip or Wayland+wl-clipboard.'
  set -g APP_AUTHOR 'Øyvind Eidhammer'
  set -g APP_C_NAME 'Øyvind Eidhammer'
  set -g APP_C_YEAR '2025'
  set -g APP_LICENSE_TYPE 'Simplified BSD License (BSD-2-Clause)'
  set -g APP_LICENSETEXT \
"Copyright (c) 2025 Øyvind Eidhammer
Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this
list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation and/or
other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
  set -g APP_VALID_DOMAINS 'youtu.be' 'youtube-nocookie.com' 'youtube.com'
  set -g APP_WSYS 'x11'                        # x11 wayland
  set -g APP_VALID_BROWSERS 'brave' 'chrome' 'chromium' 'edge' 'firefox' 'opera' 'safari' 'vivaldi' 'whale'
  set -g APP_VALID_KEYRINGS 'basictext' 'gnomekeyring' 'kwallet' 'kwallet5' 'kwallet6'
  set -g APP_DEFAULT_PROFILE "default"         # default opengl-hq sw-fast low-latency gpu-hq encoding libmpv builtin-pseudo-gui pseudo-gui
  set -g APP_DEFAULT_VIDEO_QUALITY "mid"       # low mid high highest
  set -g APP_DEFAULT_AUTOSUBS "yes"            # yes no auto auto-all
  set -g APP_USE_COOKIES_AS_DEFAULT "no"       # yes no
  set -g APP_DEFAULT_BROWSER "brave"           # brave firefox chrome
  set -g APP_DEFAULT_KEYRING "basictext"       # basictext gnomekeyring kwallet kwallet5 kwallet6
  set -g APP_DEFAULT_ALLOW_CFG "no"            # yes no
  set -g APP_USE_LOGGING_AS_DEFAULT "no"       # yes no
  set -g APP_DEFAULT_USER_AGENT "Mozilla/5.0"  # USER-AGENT STRING
  set -g APP_USE_CACHE_AS_DEFAULT "yes"        # yes no
  set -g APP_CACHE_DEMUX_SIZE "512MiB"         # MiB NUMBER
  set -g APP_CACHE_DEMUX_BACK_SIZE "256MiB"    #
  set -g APP_CACHE_SECS_SIZE "3600"            # NUMBER
  set -g APP_USE_HQ_CODECS_AS_DEFAULT "yes"    # yes no

  argparse 'profile=' 'profiles' 'profile-info=' 'quality=' 'autosubs=' 'subs=' 'see-subs' 'see-trans-subs' 'see-auto-subs' 'see-all-subs' 'see-subs-matching=' 'cookies=' 'browser=' 'browsers' 'keyring=' 'keyrings' 'allow-cfg=' 'logging=' 'hwdec=' 'gpu-ctx=' 'gpu-api' 'vo=' 'ao=' 'drivers' 'valid-domains' 'user-agent=' 'screen=' 'fullscreen=' 'cache=' 'demux-size=' 'demux-back-size=' 'secs-size=' 'hq-codecs=' 'vf=' 'vf-extra=' 'af=' 'af-extra=' 'save-as=' 'gpu-vals' 'hwdecoding' 'vfilters' 'afilters' 'verbose' 'license' 'help' -- $argv ; or return
  
  if set -ql _flag_help
    printf "\n"
    printf '         %s' (set_color --bold) (echo $APP_NAME)
    printf '%s' ' (v. ' (echo $APP_VERSION) ')' (set_color normal;)
    printf "\nA Fish shell script that lets you open a clipboarded URL\n"
    printf "to a YouTube video in 'mpv' media player, using applied\n"
    printf "CLI options and/or config variables.\n"
    printf "\n"
    printf '%s' (set_color --bold) 'USAGE' (set_color normal;)
    printf "\n"
    printf ' %s' (set_color --bold) (echo $APP_NAME) (set_color normal;)
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--profile ID' (set_color normal;) ']'
    printf "%15s # Use a 'mpv' config profile (see "
    printf '%s' (set_color --bold) (echo $APP_NAME) ' --profiles' (set_color normal;) ')'
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--save-as NAME.mp4|mkv' (set_color normal;) ']'
    printf '%5s # Save stream to a file in working directory'
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--quality low|mid|high(est)' (set_color normal;) ']'
    printf ' # Video quality limit (def: mid/480p)'
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--hwdec [API,]yes|no|auto.. ' (set_color normal;)
    printf ' # Hardware decoding (def: no - see '
    printf '%s' (set_color --bold) (echo $APP_NAME) ' --hwdecoding' (set_color normal;) ')'
    printf "\n%4s"
    printf '%s' '[' (set_color --bold) '--gpu-ctx auto|CONTEXTS' (set_color normal;) ']'
    printf '%3s # GPU context|API(,s) to be used'
    printf "\n%4s"
    printf '%s' '[' (set_color --bold) '--gpu-api auto|APIS]' (set_color normal;) ']'
    printf "%6s #"
    printf '%s' ' (def: auto - see ' (set_color --bold) (echo $APP_NAME) ' --gpu-vals' (set_color normal;) ')'
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--allow-cfg yes|no' (set_color normal;) ']'
    printf "%9s # Enable settings in ~/config/mpv files (def: no)"
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--ao|vo DRIVER' (set_color normal;) ']'
    printf '%13s # Audio|video driver/output (see '
    printf '%s' (set_color --bold) (echo $APP_NAME) ' --drivers' (set_color normal;) ')'
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--af|vf FILTERS|none' (set_color normal;) ']'
    printf "%7s # 'mpv' audio|video filter(s,) (see "
    printf '%s' (set_color --bold) (echo $APP_NAME) ' --a|vfilters' (set_color normal;) ')'
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--af|vf-extra FILTERS' (set_color normal;) ']'
    printf '%6s # Add extra audio|video filter(s,) '
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--hq-codecs yes|no' (set_color normal;) ']'
    printf "%9s # Use high quality video/audio codecs (def: yes)"
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--fullscreen yes|no' (set_color normal;) ']'
    printf "%8s # Show video in fullscreen mode (def: no)"
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--screen default|0-32' (set_color normal;) ']'
    printf "%6s # Screen to use when multiple monitors are present"
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--user-agent STRING' (set_color normal;) ']'
    printf "%8s # Network user agent string (def: 'Mozilla/5.0')"
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--subs en|de|es|fr|LCODE' (set_color normal;)
    printf "%4s # Language code - CC/subtitles to use for the video"
    printf "\n%4s"
    printf '%s' '[' (set_color --bold) '--autosubs yes|no' (set_color normal;) ']]'
    printf "%8s # Use auto-generated subtitles (def: no)"
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--see-[all|auto|trans-]subs' (set_color normal;) ']'
    printf "%1s# See available (auto-)captions/subtitles and exit"
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--see-subs-maching LCODES' (set_color normal;) ']'
    printf "%2s # See available subs matching language code(s,) and exit"
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--cache yes|no' (set_color normal;)
    printf "%14s # Enable an in-memory cache for the video stream (def: yes)"
    printf "\n%4s"
    printf '%s' '[' (set_color --bold) '--demux-size BYTESIZE' (set_color normal;)
    printf "]%5s # Limit how much the cache demuxer should read ahead or"
    printf "\n%4s"
    printf '%s' '[' (set_color --bold) '--demux-back-size BYTESIZE' (set_color normal;)
    printf "]%1s# preserve of the video stream (def: '512MiB'/'256MiB')"
    printf "\n%4s"
    printf '%s' '[' (set_color --bold) '--secs-size INTEGER' (set_color normal;)
    printf "]]%6s # Limit size of cache to number of seconds (def: 3600) "
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--logging yes|no' (set_color normal;) ']'
    printf "%11s # Log viewing to ~/tubeslog.txt (def: no)"
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--cookies yes|no' (set_color normal;)
    printf "%12s # Use cookies of a browser for authentication (def: no)"
    printf "\n%4s"
    printf '%s' '[' (set_color --bold) '--browser brave|BROWSER' (set_color normal;)
    printf "]%3s # Browser app to use (supported: "
    printf '%s' (set_color --bold) (echo $APP_NAME) ' --browsers' (set_color normal;) ')'
    printf "\n%4s"
    printf '%s' '[' (set_color --bold) '--keyring basictext|KEYR' (set_color normal;)
    printf "]]  # Keyring auth method (supported: "
    printf '%s' (set_color --bold) (echo $APP_NAME) ' --keyrings' (set_color normal;) ')'
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--verbose' (set_color normal;) ']'
    printf "%18s # Run in verbose mode"
    printf "\n%3s"
    printf '%s' '[' (set_color --bold) '--valid-domains' (set_color normal;) ']'
    printf "%12s # See a list of connectable domains and exit"
    printf "\n"
    printf "%1s YOUTUBE-VIDEO-URL-FROM-CLIPBOARD\n"
    printf "\n"
    printf '%s' (set_color --bold) 'CONFIG VARIABLES' (set_color normal;)
    printf "\n"
    printf '%s%s   %s%s     %s%s     %s%s        %s%s             %s%s\n' (echo $APP_NAME) '_profile' (echo $APP_NAME) '_vo' (echo $APP_NAME) '_autosubs' (echo $APP_NAME) '_hwdec' (echo $APP_NAME) '_cache' (echo $APP_NAME) '_wsys'
    printf '%s%s   %s%s     %s%s      %s%s      %s%s\n' (echo $APP_NAME) '_quality' (echo $APP_NAME) '_ao' (echo $APP_NAME) '_logging' (echo $APP_NAME) '_gpu_ctx' (echo $APP_NAME) '_secs_size'
    printf '%s%s   %s%s     %s%s       %s%s      %s%s\n' (echo $APP_NAME) '_cookies' (echo $APP_NAME) '_vf' (echo $APP_NAME) '_screen' (echo $APP_NAME) '_gpu_api' (echo $APP_NAME) '_demux_size'
    printf '%s%s   %s%s     %s%s   %s%s   %s%s\n' (echo $APP_NAME) '_browser' (echo $APP_NAME) '_af' (echo $APP_NAME) '_fullscreen' (echo $APP_NAME) '_user_agent' (echo $APP_NAME) '_demux_back_size'
    printf '%s%s   %s%s   %s%s    %s%s    %s%s\n' (echo $APP_NAME) '_keyring' (echo $APP_NAME) '_subs' (echo $APP_NAME) '_hq_codecs' (echo $APP_NAME) '_allow_cfg' (echo $APP_NAME) '_valid_domains'
    printf "\n"
    printf '%s' (set_color --bold) 'EXAMPLES' (set_color normal;)
    printf '\n'
    printf "(1) High/720p quality, french subs and logging\n"
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --quality high --subs fr --autosubs no --logging yes' (set_color normal;))
    printf "(2) Hardware decoding on Wayland window system + Vulkan (requires 'wl-clip')\n"
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_wsys wayland' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_vo gpu-next' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_gpu_api vulkan' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_gpu_ctx waylandvk' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --hwdec vulkan' (set_color normal;))
    printf "(3) Available subtitles\n"
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --see-subs' (set_color normal;) '                   # non-automatic')
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --see-auto-subs' (set_color normal;) '              # auto-generated' )
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --see-trans-subs' (set_color normal;) '             # translated from a-g')
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --see-all-subs' (set_color normal;) '               # all the above' )
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --see-subs-matching fr,de,en' (set_color normal;) ' # german, french, and english subs' )
    printf "(4) Authentication using Brave browser cookies and 'basictext' keyring method\n"
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --cookies yes --browser brave --keyring basictext' (set_color normal;))
    printf "(5) Fast software decoding, 1080p, best codecs, fullscreen (good for old hardware)\n"
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --profile sw-fast --quality highest --hq-codecs yes --fullscreen yes' (set_color normal;))
    printf "(6) Practical video filters\n"
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --quality low --vf \'scale=w=2*iw:h=2*ih\'' (set_color normal;) '     # scale 360p * 2' )
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --quality highest --vf \'scale=w=iw/2:h=ih/2\'' (set_color normal;) ' # scale 1080p * 1/2' )
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --vf \'fade=in:0:90,hue=s=0\'' (set_color normal;) '                  # fade in + black/white effect' )
    printf "(7) Change default settings\n"
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_profile sw-fast' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_quality high' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_cookies yes' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_browser firefox' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_keyring gnomekeyring' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_vo libmpv' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_ao coreaudio' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_vf \'hqdn3d\'' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_af \'dynaudnorm=b=1:g=3\'' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_subs en,fr,de' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_autosubs yes' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_logging yes' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_screen 2' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_fullscreen yes' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_hq_codecs yes' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_hwdec no' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_gpu_api auto' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_gpu_ctx auto' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_user_agent \'Mac OS X/Safari 17\'' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_allow_cfg yes' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_cache yes' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_secs_size 1200' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_demux_size 150M' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_demux_back_size 400M' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_wsys x11' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_valid_domains \'youtu.be\' \'youtube-nocookie.com\' \'youtube.com\' \'news.sky.com\'' (set_color normal;))
    printf "(8) Default and extra filter\n"
    printf '    %s\n' (printf '%s' (set_color --bold) 'set -x ' (echo $APP_NAME) '_vf \'scale=w=2*iw:h=2*ih\'' (set_color normal;))
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --quality mid --vf-extra \'eq=brightness=0.1:contrast=1.2:saturation=0.75\'' (set_color normal;))
    printf "(9) Save stream as a file (note: filters and hardware decoding should not be used)\n"
    printf '    %s\n' (printf '%s' (set_color --bold) (echo $APP_NAME) ' --save-as \'NeilBreenEatsCannedTuna.mkv\' --hwdec no --vf none --af none' (set_color normal;))
    printf "\n"
    printf '%s' (set_color --bold) 'REQUIREMENTS' (set_color normal;)
    printf "\n"
    echo -e (string replace ',perl' ',\nperl' $APP_REQUIREMENTS | string replace 'or a ' 'or a\n' | string replace -r -a ',' ', ')
    printf "\n"
    printf '%s' (set_color --bold) 'AUTHOR' (set_color normal;)
    printf "\n"
    printf '%s\n' $APP_AUTHOR
    printf "\n"
    printf '%s' (set_color --bold) 'COPYRIGHT' (set_color normal;)
    printf '\n'
    printf '%s\n' (printf '%s' 'Copyright (C) ' (echo $APP_C_YEAR) ' ' (echo $APP_C_NAME) '.')
    printf '%s\n' (printf '%s' 'License: ' (echo $APP_LICENSE_TYPE | string replace -r '\(.+\)' '' | string replace -r -a '(License|license)' '' | string replace -r -a '\s+' ' ') '(see ' (set_color --bold) (echo $APP_NAME) ' --license' (set_color normal;) ')')
    printf "\n"
    return 0
  end

  if set -ql _flag_hwdecoding
    printf '%s' 'Hardware video decoding (' (set_color --bold) (echo $APP_NAME) ' --hwdec [API,]yes,no,auto[-safe|-copy|-copy-safe]' (set_color normal;) '):'
    printf "\n"
    printf "%s\n" (mpv --hwdec=help | perl -ne 'print if $. >= 2')
    return 0
  end

  if set -ql _flag_drivers
    printf '%s' 'Video drivers (' (set_color --bold) (echo $APP_NAME) ' --vo DRIVER' (set_color normal;) '):'
    printf "\n"
    printf "%s\n" (mpv --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo=help | perl -ne 'print if $. >= 2')
    printf '%s' 'Audio drivers (' (set_color --bold) (echo $APP_NAME) ' --ao DRIVER' (set_color normal;) '):'
    printf "\n"
    printf "%s\n" (mpv --ao=help | perl -ne 'print if $. >= 2')
    return 0
  end

  if set -ql _flag_afilters
    printf '%s' 'Audio filters (' (set_color --bold) (echo $APP_NAME) ' --af none|FILTER1[=PARAM1:PARAM2,..],FILTER2[=PARAM1:PARAM2,..],..' (set_color normal;) '):'
    printf "\n"
    printf "%s\n" (mpv --af=help | perl -ne 'print if $. >= 2' | perl -nle 'print if not /^Get help.+$/ .. /^\s*$/' )
    return 0
  end

  if set -ql _flag_vfilters
    printf '%s' 'Video filters (' (set_color --bold) (echo $APP_NAME) ' --vf none|FILTER1[=PARAM1:PARAM2,..],FILTER2[=PARAM1:PARAM2,..],..' (set_color normal;) '):'
    printf "\n"
    printf "%s\n" (mpv --vf=help | perl -ne 'print if $. >= 2' | perl -nle 'print if not /^Get help.+$/ .. /^\s*$/' )
    return 0
  end

  if set -ql _flag_profiles
    printf '%s' 'Config profiles (' (set_color --bold) (echo $APP_NAME) ' --profile ID' (set_color normal;) '):'
    printf "\n%s" (mpv --profile=help | perl -ne 'print if $. >= 2')
    printf '\n'
    printf '%s' 'Use ' (set_color --bold) (echo $APP_NAME) ' --profile-info ID' (set_color normal;)
    printf "\nto view settings of a profile.\n\n"
    printf '%s' 'Note that ' (set_color --bold) (echo $APP_NAME) ' --allow-cfg yes' (set_color normal;) ' is required for'
    printf '\n'
    printf '%s' 'usage of profiles defined in ' (set_color --bold) '~/.config/mpv/mpv.conf' (set_color normal;) '.'
    printf '\n\n'
    return 0
  end

  if set -ql _flag_profile_info
    set -g CFGINFOPROFILE (echo $_flag_profile_info)
    printf '%s' "Setttings for profile '" (echo $CFGINFOPROFILE) "'" ' (' (set_color --bold) (echo $APP_NAME) ' --profile ' (echo $CFGINFOPROFILE) (set_color normal;) '):'
    printf "\n%s" (mpv --show-profile="$CFGINFOPROFILE" | perl -ne 'print if $. >= 2')
    printf "\n"
    return 0
  end

  if set -ql _flag_browsers
    printf '%s' 'Supported browsers (' (set_color --bold) (echo $APP_NAME) ' --browser APP' (set_color normal;) '):'
    printf "\n"
    for app in $APP_VALID_BROWSERS
        printf "  %s\n" $app
    end
    printf "\n"
    return 0
  end

  if set -ql _flag_keyrings
    printf '%s' 'Supported keyring methods (' (set_color --bold) (echo $APP_NAME) ' --keyring METHOD' (set_color normal;) '):'
    printf "\n"
    for met in $APP_VALID_KEYRINGS
        printf "  %s\n" $met
    end
    printf "\n"
    return 0
  end

  if set -ql _flag_gpu_vals
    printf '%s' 'GPU contexts (' (set_color --bold) (echo $APP_NAME) ' --gpu-context CONTEXT1,CONTEXT2..' (set_color normal;) '):'
    printf "\n"
    printf "%s\n" (mpv --gpu-context=help | perl -ne 'print if $. >= 2' )
    printf '%s' 'GPU APIS (' (set_color --bold) (echo $APP_NAME) ' --gpu-api API1,API2..' (set_color normal;) '):'
    printf "\n"
    printf "%s\n" (mpv --gpu-api=help | perl -ne 'print if $. >= 2' )
    return 0
  end

  if set -ql _flag_license
    printf "%s" (set_color --bold) (echo $APP_LICENSE_TYPE) (set_color normal;)
    printf "\n"
    echo "$APP_LICENSETEXT"
    printf "\n"
    return 0
  end

  for req in fish mpv youtube-dl perl
    if not type -q $req
      printf "Requirement '$req' not found.\nPlease make it available in the shell."
      return 1
    end
  end

  if not test (uname) = "Darwin"
    if test -n "$ytp_wsys"
      set -g WSYS (echo $ytp_wsys | string lower)
    else
      set -g WSYS (echo $APP_WSYS | string lower)
    end
    if test $WSYS = "x11"
      if not type -q xclip
        printf "Requirement 'xclip' not found.\nPlease make it available in the shell."
        return 1
      end
      alias pbpaste "xclip -selection clipboard -o"
    else
      if not type -q wl-paste
        printf "Requirement 'wl-paste' (from 'wl-pasteboard') not found.\nPlease make it available in the shell."
        return 1
      end
      alias pbpaste "wl-paste"
    end
  end

  if type -q ggrep
    alias grep "ggrep"
  else
    if not type -q grep
      printf "Requirement 'GNU grep' not found. Please make it available in the shell as symlink 'ggrep'"
      return 1
    end
    if not grep --version 2>&1 | string match -r -q 'GNU grep'
      printf "Found 'grep' is not a required 'GNU grep' command. Please make a GNU version available as a symlink 'ggrep'"
      return 1
    end
  end

  if type -q gdate
    alias date "gdate"
  else
    if not type -q date
      printf "Requirement 'GNU date/coreutils' not found. Please make it available in the shell as symlink 'gdate'"
      return 1
    end
    if not date --version 2>&1 | string match -r -q 'GNU coreutils'
      printf "Found 'date' is not a required 'GNU date' command. Please make a GNU version available as a symlink 'gdate'"
      return 1
    end
  end

  set -g PROFILE (echo $_flag_profile)

  if test -z "$PROFILE"
    if test -n "$ytp_profile"
      set -g PROFILE $ytp_profile
    else
      set -g PROFILE $APP_DEFAULT_PROFILE
    end
  end

  set -g HQ_CODECS (echo $_flag_hq_codecs | string lower)

  if test -z "$HQ_CODECS"
    if test -n "$ytp_hq_codecs"
      set -g HQ_CODECS (echo $ytp_hq_codecs | string lower)
    else
      set -g HQ_CODECS (echo $APP_USE_HQ_CODECS_AS_DEFAULT | string lower)
    end
  end

  set -g VIDEOQUALITY (echo $_flag_quality | string lower)

  if test -z "$VIDEOQUALITY"
    if test -n "$ytp_quality"
      set -g VIDEOQUALITY (echo $ytp_quality | string lower)
    else
      set -g VIDEOQUALITY (echo $APP_DEFAULT_VIDEO_QUALITY | string lower)
    end
  end

  if test $HQ_CODECS = "yes"
    switch $VIDEOQUALITY
      case low
        set -g VIDEOQUALITYPARM "((bestvideo[height<=?360][fps<=?30][vcodec~='vp0?9']/bestvideo)+(bestaudio[acodec=opus]/bestaudio[acodec=vorbis]/bestaudio[acodec=aac]/bestaudio))/best"
      case mid
        set -g VIDEOQUALITYPARM "((bestvideo[height<=?480][fps<=?30][vcodec~='vp0?9']/bestvideo)+(bestaudio[acodec=opus]/bestaudio[acodec=vorbis]/bestaudio[acodec=aac]/bestaudio))/best"
      case high
        set -g VIDEOQUALITYPARM "((bestvideo[height<=?720][fps<=?30][vcodec~='vp0?9']/bestvideo)+(bestaudio[acodec=opus]/bestaudio[acodec=vorbis]/bestaudio[acodec=aac]/bestaudio))/best"
      case highest
        set -g VIDEOQUALITYPARM "((bestvideo[height<=?1080][fps<=?30][vcodec~='vp0?9']/bestvideo)+(bestaudio[acodec=opus]/bestaudio[acodec=vorbis]/bestaudio[acodec=aac]/bestaudio))/best"
      case *
        set -g VIDEOQUALITYPARM "((bestvideo[height<=?480][fps<=?30][vcodec~='vp0?9']/bestvideo)+(bestaudio[acodec=opus]/bestaudio[acodec=vorbis]/bestaudio[acodec=aac]/bestaudio))/best"
      end
  else
    switch $VIDEOQUALITY
      case low
        set -g VIDEOQUALITYPARM "(bestvideo[height<=?360][fps<=?30][vcodec!~='vp0?9'])+bestaudio/best"
      case mid
        set -g VIDEOQUALITYPARM "(bestvideo[height<=?480][fps<=?30][vcodec!~='vp0?9'])+bestaudio/best"
      case high
        set -g VIDEOQUALITYPARM "(bestvideo[height<=?720][fps<=?30][vcodec!~='vp0?9'])+bestaudio/best"
      case highest
        set -g VIDEOQUALITYPARM "bestvideo[height<=?1080][fps<=?30][vcodec!~='vp0?9']+bestaudio/best"
      case *
        set -g VIDEOQUALITYPARM "bestvideo[height<=?480][fps<=?30][vcodec!~='vp0?9']+bestaudio/best"
    end
  end

  set -g AUTOSUBS (echo $_flag_autosubs | string lower)

  if test -z "$AUTOSUBS"
    if test -n "$ytp_autosubs"
      set -g AUTOSUBS (echo $ytp_autosubs | string lower)
    else
      set -g AUTOSUBS (echo $APP_DEFAULT_AUTOSUBS | string lower)
    end
  end

  set -g SUBS (echo $_flag_subs | string lower)

  if test "$SUBS" = "none"
    set -g SUBS ""
  else
    if test -z "$SUBS"
      if test -n "$ytp_subs"
        set -g SUBS (echo $ytp_subs | string lower)
      end
    end
  end

  set -g COOKIES (echo $_flag_cookies | string lower)

  if test "$COOKIES" = "yes"
    set -g USE_COOKIES "yes"
  else
    if test -n "$ytp_cookies"
      set -g USE_COOKIES (echo $ytp_cookies | string lower)
    else
      set -g USE_COOKIES (echo $APP_USE_COOKIES_AS_DEFAULT | string lower)
    end
  end

  if test "$USE_COOKIES" = "yes"
    set -g BROWSERKEYRING (echo $_flag_keyring | string lower)
    set -g BROWSERAPP (echo $_flag_browser | string lower)

    if test -z "$BROWSERKEYRING"
      if test -n "$ytp_keyring"
        set -g BROWSERKEYRING (echo $ytp_keyring | string lower)
      else
        set -g BROWSERKEYRING (echo $APP_DEFAULT_KEYRING | string lower)
      end
    end

    if test -z "$BROWSERAPP"
      if test -n "$ytp_browser"
        set -g BROWSERAPP (echo $ytp_browser | string lower)
      else
        set -g BROWSERAPP (echo $APP_DEFAULT_BROWSER | string lower)
      end
    end
  else
    set -g BROWSERKEYRING ""
    set -g BROWSERAPP ""
  end

  set -g ALLOWCFG (echo $_flag_allow_cfg | string lower)

  if test -z "$ALLOWCFG"
    if test -n "$ytp_allow_cfg"
      set -g ALLOWCFG (echo $ytp_allow_cfg | string lower)
    else
      set -g ALLOWCFG (echo $APP_DEFAULT_ALLOW_CFG | string lower)
    end
  end

  set -g LOGGING (echo $_flag_logging | string lower)

  if test "$LOGGING" = "yes"
    set -g USE_LOGGING "yes"
  else
    if test -n "$ytp_logging"
      set -g USE_LOGGING (echo $ytp_logging | string lower)
    else
      set -g USE_LOGGING (echo $APP_USE_LOGGING_AS_DEFAULT | string lower)
    end
  end

  set -g AO (echo $_flag_ao)

  if test -z "$AO"
    if test -n "$ytp_ao"
      set -g AO $ytp_ao
    end
  end

  set -g VO (echo $_flag_vo)

  if test -z "$VO"
    if test -n "$ytp_vo"
      set -g VO $ytp_vo
    end
  end

  set -g HWDEC (echo $_flag_hwdec)

  if test -z "$HWDEC"
    if test -n "$ytp_hwdec"
      set -g HWDEC $ytp_hwdec
    else
      set -g HWDEC "no"
    end
  end

  if test "$HWDEC" != "no"
    set -g GPUCTX (echo $_flag_gpu_ctx)
    set -g GPUAPI (echo $_flag_gpu_api)
    if test -z "$GPUCTX"
      if test -n "$ytp_gpu_ctx"
        set -g GPUCTX $ytp_gpu_ctx
      else
        set -g GPUCTX "auto"
      end
    end
    if test -z "$GPUAPI"
      if test -n "$ytp_gpu_api"
        set -g GPUAPI $ytp_gpu_api
      else
        set -g GPUAPI "auto"
      end
    end
  else
    set -g GPUCTX "auto"
    set -g GPUAPI "auto"
  end

  set -g SAVEAS (echo $_flag_save_as)

  if test -n "$ytp_valid_domains"
    set -g VALID_DOMAINS $ytp_valid_domains
  else
    set -g VALID_DOMAINS $APP_VALID_DOMAINS
  end

  if set -ql _flag_valid_domains
    printf "Valid domains (change with 'set -g ytp_valid_domains LIST'):\n"
    for dom in $VALID_DOMAINS
      printf "  %s\n" $dom
    end
    printf "\n"
    return 0
  end

  set -g URL "$(pbpaste | perl -pe 's/&t=\d+s//' | perl -pe 's/^\s+|\s+$//g')"
  set -g DOMAIN (echo "$URL" | string match -r '(?:[\\w]+\\.)*(?:[\\w]+\\.)(?:[\\w]+)' | perl -pe 's/www\.//')

  if not contains $DOMAIN $VALID_DOMAINS
    printf "Error: pasted text '%s' may not be a correct address\n" $URL
    printf "Valid domains are:\n"
    for dom in $VALID_DOMAINS
      printf "  %s\n" $dom
    end
    printf "\nChange list of valid domains with 'set -g ytp_valid_domains LIST'\n\n"
    return 1
  end

  if set -ql _flag_see_subs
    set -l SUBSLIST (youtube-dl --no-warnings --list-subs --extractor-args "youtube:skip=dash,translated_subs" (echo "$URL"))
    printf '%s' 'Subtitles (' (set_color --bold) (echo $APP_NAME) ' --subs LANGCODE --autosubs no' (set_color normal;) '):'
    printf "\n"
    set -l OUT (printf "%s\n" $SUBSLIST | perl -ne 'print if /^\[info\] Available subtitles for/ .. eof' | perl -ne '/(^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+[A-Z]|^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+vtt|srt|ttml|srv1|srv2|srv3|json3)/ && print')
    if not string match -rq '\w' $OUT
      printf "n/a\n\n"
    else
      printf "%s\n" (printf "%s\n" $OUT | string replace -r -a '(vtt|srt|ttml|srv1|srv2|srv3|json3),*' '')
      printf "\n"
    end
    return 0
  end

  if set -ql _flag_see_auto_subs
    set -l SUBSLIST (youtube-dl --no-warnings --list-subs --extractor-args "youtube:skip=dash,translated_subs" (echo "$URL"))
    printf '%s' 'Auto-subs (' (set_color --bold) (echo $APP_NAME) ' --subs LANGCODE --autosubs yes' (set_color normal;) '):'
    printf "\n"
    set -l OUT (printf "%s\n" $SUBSLIST | perl -ne 'print if /^\[info\] Available automatic captions/ .. (/^\[info\] Available subtitles/ or eof)' | perl -ne '/(^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+[A-Z]|^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+vtt|srt|ttml|srv1|srv2|srv3|json3)/ && print'|  perl -pe 's/([a-z0-9]+,|[a-z0-9]+$)//g' | perl -pe 's/^\s*$//g')
    if not string match -rq '\w' $OUT
      printf "n/a\n\n"
    else
      printf "%s\n" (printf "%s\n" $OUT | string replace -r -a '(vtt|srt|ttml|srv1|srv2|srv3|json3),*' '')
      printf "\n"
    end
    return 0
  end

  if set -ql _flag_see_trans_subs
    set -l SUBSLIST (youtube-dl --no-warnings --list-subs --extractor-args "youtube:skip=dash" (echo "$URL"))
    printf '%s' 'Trans-auto-subs (' (set_color --bold) (echo $APP_NAME) ' --subs LANGCODE --autosubs yes' (set_color normal;) '):'
    printf "\n"
    set -l OUT (printf "%s\n" $SUBSLIST | perl -ne 'print if /^\[info\] Available automatic captions/ .. (/^\[info\] Available subtitles/ or eof)' | perl -ne '/(^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+[A-Z]|^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+vtt|srt|ttml|srv1|srv2|srv3|json3)/ && print' | perl -ne 'print if /[a-z)] from \w/')
    if not string match -rq '\w' $OUT
      printf "n/a\n\n"
    else
      printf "%s\n" (printf "%s\n" $OUT | string replace -r -a '(vtt|srt|ttml|srv1|srv2|srv3|json3),*' '')
      printf "\n"
    end
    return 0
  end

  if set -ql _flag_see_all_subs
    set -l SUBSLIST (youtube-dl --no-warnings --list-subs --extractor-args "youtube:skip=dash" (echo "$URL"))
    printf '%s' 'Subtitles (' (set_color --bold) (echo $APP_NAME) ' --subs LANGCODE --autosubs no' (set_color normal;) '):'
    printf "\n"
    set -l OUT (printf "%s\n" $SUBSLIST | perl -ne 'print if /^\[info\] Available subtitles for/ .. eof' | perl -ne '/(^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+[A-Z]|^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+vtt|srt|ttml|srv1|srv2|srv3|json3)/ && print' | perl -ne 'print if not /[a-z)] from \w/')
    if not string match -rq '\w' $OUT
      printf "n/a\n\n"
    else
      printf "%s\n" (printf "%s\n" $OUT | string replace -r -a '(vtt|srt|ttml|srv1|srv2|srv3|json3),*' '')
      printf "\n"
    end
    printf '%s' 'Auto-subs (' (set_color --bold) (echo $APP_NAME) ' --subs LANGCODE --autosubs yes' (set_color normal;) '):'
    printf "\n"
    set -l OUT (printf "%s\n" $SUBSLIST | perl -ne 'print if /^\[info\] Available automatic captions/ .. (/^\[info\] Available subtitles/ or eof)' | perl -ne '/(^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+[A-Z]|^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+vtt|srt|ttml|srv1|srv2|srv3|json3)/ && print'| perl -ne 'print if not /[a-z)] from \w/' | perl -pe 's/([a-z0-9]+,|[a-z0-9]+$)//g' | perl -pe 's/^\s*$//g')
    if not string match -rq '\w' $OUT
      printf "n/a\n\n"
    else
      printf "%s\n" (printf "%s\n" $OUT | string replace -r -a '(vtt|srt|ttml|srv1|srv2|srv3|json3),*' '')
      printf "\n"
    end
    printf '%s' 'Trans-auto-subs (' (set_color --bold) (echo $APP_NAME) ' --subs LANGCODE --autosubs yes' (set_color normal;) '):'
    printf "\n"
    set -l OUT (printf "%s\n" $SUBSLIST | perl -ne 'print if /^\[info\] Available automatic captions/ .. (/^\[info\] Available subtitles/ or eof)' | perl -ne '/(^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+[A-Z]|^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+vtt|srt|ttml|srv1|srv2|srv3|json3)/ && print' | perl -ne 'print if /[a-z)] from \w/')
    if not string match -rq '\w' $OUT
      printf "n/a\n\n"
    else
      printf "%s\n" (printf "%s\n" $OUT | string replace -r -a '(vtt|srt|ttml|srv1|srv2|srv3|json3),*' '')
      printf "\n"
    end
    return 0
  end

  set -l SUBMATCHWORD (echo $_flag_see_subs_matching)

  if test -n "$SUBMATCHWORD"
    set -l SUBMATCHWORD (echo "$SUBMATCHWORD" | string replace -r -a '[ ]*,[ ]*' '|' )
    set -l SUBSLIST (youtube-dl --no-warnings --list-subs --extractor-args "youtube:skip=dash" (echo "$URL"))
    set -l QUERYSTRING (printf "^%s.*\$" "($SUBMATCHWORD)")
    printf '%s' 'Subtitles (' (set_color --bold) (echo $APP_NAME) ' --subs LANGCODE --autosubs no' (set_color normal;) '):'
    printf "\n"
    set -l OUT (printf "%s\n" $SUBSLIST | perl -ne 'print if /^\[info\] Available subtitles for/ .. eof' | perl -ne '/(^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+[A-Z]|^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+vtt|srt|ttml|srv1|srv2|srv3|json3)/ && print' | perl -ne 'print if not /[a-z)] from \w/')
    if not string match -rq '\w' $OUT
      printf "n/a\n\n"
    else
      string match -r $QUERYSTRING $OUT | perl -ne 'print if (++$x)%2' | string replace -r -a '(vtt|srt|ttml|srv1|srv2|srv3|json3),*' ''
      printf "\n"
    end
    printf '%s' 'Auto-subs (' (set_color --bold) (echo $APP_NAME) ' --subs LANGCODE --autosubs yes' (set_color normal;) '):'
    printf "\n"
    set -l OUT (printf "%s\n" $SUBSLIST | perl -ne 'print if /^\[info\] Available automatic captions/ .. (/^\[info\] Available subtitles/ or eof)' | perl -ne '/(^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+[A-Z]|^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+vtt|srt|ttml|srv1|srv2|srv3|json3)/ && print'| perl -ne 'print if not /[a-z)] from \w/' | perl -pe 's/([a-z0-9]+,|[a-z0-9]+$)//g' | perl -pe 's/^\s*$//g')
    if not string match -rq '\w' $OUT
      printf "n/a\n\n"
    else
      string match -r $QUERYSTRING $OUT | perl -ne 'print if (++$x)%2' | string replace -r -a '(vtt|srt|ttml|srv1|srv2|srv3|json3),*' '' | string replace '' 'n/a'
      printf "\n"
    end
    printf '%s' 'Trans-auto-subs (' (set_color --bold) (echo $APP_NAME) ' --subs LANGCODE --autosubs yes' (set_color normal;) '):'
    printf "\n"
    set -l OUT (printf "%s\n" $SUBSLIST | perl -ne 'print if /^\[info\] Available automatic captions/ .. (/^\[info\] Available subtitles/ or eof)' | perl -ne '/(^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+[A-Z]|^[a-z]{2,4}[a-zA-Z0-9-]*[ ]+vtt|srt|ttml|srv1|srv2|srv3|json3)/ && print' | perl -ne 'print if /[a-z)] from \w/')
    if not string match -rq '\w' $OUT
      printf "n/a\n\n"
    else
      string match -r $QUERYSTRING $OUT | perl -ne 'print if (++$x)%2' | string replace -r -a '(vtt|srt|ttml|srv1|srv2|srv3|json3),*' '' | string replace '' 'n/a'
      printf "\n"
    end
    return 0
  end

  set -g USER_AGENT (echo $_flag_user_agent)

  if test -z "$USER_AGENT"
    if test -n "$ytp_user_agent"
      set -g USER_AGENT $ytp_user_agent
    else
      set -g USER_AGENT $APP_DEFAULT_USER_AGENT
    end
  end

  set -g SCREEN (echo $_flag_screen)

  if test -z "$SCREEN"
    if test -n "$ytp_screen"
      set -g SCREEN $ytp_screen
    else
      set -g SCREEN "default"
    end
  end

  set -g FULLSCREEN (echo $_flag_fullscreen | string lower)

  if test -z "$FULLSCREEN"
    if test -n "$ytp_fullscreen"
      set -g FULLSCREEN (echo $ytp_fullscreen | string lower)
    else
      set -g FULLSCREEN "no"
    end
  end

  set -g CACHE (echo $_flag_cache | string lower)

  if test -z "$CACHE"
    if test -n "$ytp_cache"
      set -g CACHE (echo $ytp_cache | string lower)
    else
      set -g CACHE (echo $APP_USE_CACHE_AS_DEFAULT | string lower)
    end
  end

  if test "$CACHE" = "yes"
    set -g CACHE "yes"
    set -g DEMUXSIZE (echo $_flag_demux_size)
    set -g DEMUXBACKSIZE (echo $_flag_demux_back_size)
    set -g SECSSIZE (echo $_flag_secs_size)
    if test -z "$DEMUXSIZE"
      if test -n "$ytp_demux_size"
        set -g DEMUXSIZE $ytp_demux_size
      else
        set -g DEMUXSIZE $APP_CACHE_DEMUX_SIZE
      end
    end
    if test -z "$DEMUXBACKSIZE"
      if test -n "$ytp_demux_back_size"
        set -g DEMUXBACKSIZE $ytp_demux_back_size
      else
        set -g DEMUXBACKSIZE $APP_CACHE_DEMUX_BACK_SIZE
      end
    end
    if test -z "$SECSSIZE"
      if test -n "$ytp_secs_size"
        set -g SECSSIZE $ytp_secs_size
      else
        set -g SECSSIZE $APP_CACHE_SECS_SIZE
      end
    end
    set -g DEMUXSIZEPRT "$DEMUXSIZE"
    set -g DEMUXBACKSIZEPRT "$DEMUXBACKSIZE"
    set -g SECSSIZEPRT "$SECSSIZE"
  else
    set -g CACHE "no"
    set -g DEMUXSIZE "400MiB"
    set -g DEMUXBACKSIZE "150MiB"
    set -g SECSSIZE "60"
    set -g DEMUXSIZEPRT "-"
    set -g DEMUXBACKSIZEPRT "-"
    set -g SECSSIZEPRT "-"
  end

  set -g VF (echo $_flag_vf)

  if test (string lower "$VF") = "none"
    set -g VF ""
  else
    if test -z "$VF"
      if test -n "$ytp_vf"
        set -g VF $ytp_vf
      end
    end
  end

  set -g VFEXTRA (echo $_flag_vf_extra)

  if test -n "$VFEXTRA"
    if test -z "$VF"
      set -g VF $VFEXTRA
    else
      set -g VF (string join ',' $VF $VFEXTRA)
    end
  end

  set -g AF (echo $_flag_af)


  if test (string lower "$AF") = "none"
    set -g AF ""
  else
    if test -z "$AF"
      if test -n "$ytp_af"
        set -g AF $ytp_af
      end
    end
  end

  set -g AFEXTRA (echo $_flag_af_extra)

  if test -n "$AFEXTRA"
    if test -z "$AF"
      set -g AF $AFEXTRA
    else
      set -g AF (string join ',' $AF $AFEXTRA)
    end
  end

  if test "$USE_COOKIES" = "yes"
    set -g META (youtube-dl --no-warnings --cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING -j $URL)
  else
    set -g META (youtube-dl --no-warnings -j $URL)
  end 

  set -g TITLE (echo $META | grep -o '"fulltitle": .*, "duration_string"' | perl -pe 's/"fulltitle": "//;' | perl -pe 's/", "duration_string"//;' | perl -pe 's/\\\"/"/g;')
  set -g UPLOADDATE (echo $META | grep -o '"upload_date": "[^"]*"' | perl -pe 's/"upload_date": //g;' | perl -pe 's/["]//g;')
  set -g DURATION (echo $META | grep -o '"duration_string": "[^"]*"' | perl -pe 's/"duration_string": //g;' | perl -pe 's/["]//g;')
  set -g CHANNEL (echo $META | grep -o '"channel": "[^"]*"' | perl -pe 's/"channel": //g;' | perl -pe 's/["]//g;')
  set -g UPLDATE (date --date="$UPLOADDATE" "+%m-%b-%Y" | string replace -r '([a-z])' '\U$0')
  set -g VIDEOTEXT "$TITLE [Dur $DURATION Pub $UPLDATE]"
  set -g URLTEXT "  * $URL"
  set -g CHANNELTEXT "  * $CHANNEL"
  set -g DATETEXT "  * Viewed $(date +"%A %m/%d/%Y (%H:%M)")"
  
  printf '%s' (set_color --bold) 'SETTINGS  ' (set_color normal;)
  printf 'Profile:%s  ' $PROFILE
  printf 'Quality:%s  ' (echo "$VIDEOQUALITY" | perl -pe 's/low/low\/360p/' | perl -pe 's/mid/mid\/480p/' | perl -pe 's/^high$/high\/720p/' | perl -pe 's/highest/highest\/1080p/')
  
  if test "$AUTOSUBS" = "yes"
    if test -n "$SUBS"
      printf 'Subs:auto-%s(on/off/switch: \'j\')  ' (echo $SUBS | perl -pe 's/^$/-/')
    else
      printf 'Subs:-  '
    end
  else
    if test -n "$SUBS"
      printf 'Subs:%s(on/off/switch: \'j\')  ' (echo $SUBS | perl -pe 's/^$/-/')
    else
      printf 'Subs:-  '
    end
  end
 
  printf '[Cookies:%s  Browser:%s  Keyring:%s]\n' $USE_COOKIES (echo $BROWSERAPP | perl -pe 's/^$/-/') (echo $BROWSERKEYRING | perl -pe 's/^$/-/')
  printf '%10sAllowConfigFiles:'
  printf '%s  ' $ALLOWCFG
  printf 'Logging:%s  ' $USE_LOGGING
  printf 'HWDec:%s  ' (echo $HWDEC | perl -pe 's/^$/no/')
  printf 'VideoDrv:%s  ' (echo $VO | perl -pe 's/^$/default/')
  printf 'AudioDrv:%s\n' (echo $AO | perl -pe 's/^$/default/')

  if test "$FULLSCREEN" = "yes"
    printf '%10sScreen:'
    printf '%s(FS mode)  ' (echo $SCREEN | perl -pe 's/^$/default/')
  else
    printf '%10sScreen:'
    printf '%s  ' (echo $SCREEN | perl -pe 's/^$/default/')
  end

  printf 'HQCodecs:%s  ' $HQ_CODECS
  printf '[Cache:%s  DemuxSizes:%s/%s  SecSize:%s]\n' $CACHE $DEMUXSIZEPRT $DEMUXBACKSIZEPRT $SECSSIZEPRT
  printf '%10sUserAgent:'
  printf '%s  ' $USER_AGENT
  printf 'VideoFilter:'
  printf '%s  ' $VF
  printf 'AudioFilter:%s  ' $AF
  printf '\n\n'
  printf '%s' (set_color --bold) 'VIDEO' (set_color normal;)
  printf "%5s%s\n" "" $VIDEOTEXT
  printf '%s' (set_color --bold) 'CHANNEL' (set_color normal;)
  printf "%3s%s\n" "" $CHANNEL
  printf '%s' (set_color --bold) 'URL' (set_color normal;)
  printf "%7s%s\n" "" $URL
  printf '%s' (set_color --bold) 'VIEWED' (set_color normal;)
  printf "%4s%s\n\n" "" (date +"%A %d %B, %Y (%H:%M)" | string replace -r -a '\b(\w)' '\U$0')

  if test "$USE_COOKIES" = "yes"
    if test -n "$SUBS" 
      if set -ql _flag_verbose
        if test "$AUTOSUBS" = "yes"
          if test "$ALLOWCFG" = "yes"
	          mpv -v --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="write-subs=,write-auto-sub=,cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          else
	          mpv -v --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="ignore-config=,write-subs=,write-auto-sub=,cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --no-config --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          end
        else
          if test "$ALLOWCFG" = "yes"
	          mpv -v --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="write-subs=,cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          else
	          mpv -v --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="ignore-config=,write-subs=,cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --no-config --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          end
        end
      else
        if test "$AUTOSUBS" = "yes"
          if test "$ALLOWCFG" = "yes"
	          mpv --msg-level=cplayer=no,display-tags=no,recorder=no,ffmpeg=no,mkv=no --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="write-subs=,write-auto-sub=,cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          else
	          mpv --msg-level=cplayer=no,display-tags=no,recorder=no,ffmpeg=no,mkv=no --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="ignore-config=,write-subs=,write-auto-sub=,cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --no-config --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          end
        else
          if test "$ALLOWCFG" = "yes"
	          mpv --msg-level=cplayer=no,display-tags=no,recorder=no,ffmpeg=no,mkv=no --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="write-subs=,cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          else
	          mpv --msg-level=cplayer=no,display-tags=no,recorder=no,ffmpeg=no,mkv=no --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="ignore-config=,write-subs=,cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --no-config --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          end
        end
      end
    else
      if set -ql _flag_verbose
        if test "$ALLOWCFG" = "yes"
	        mpv -v --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --ytdl-raw-options="cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING" --ytdl-format="$VIDEOQUALITYPARM" --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
        else
	        mpv -v --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --ytdl-raw-options="ignore-config=,cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING" --ytdl-format="$VIDEOQUALITYPARM" --no-config --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
        end
      else
        if test "$ALLOWCFG" = "yes"
	        mpv --msg-level=cplayer=no,display-tags=no,recorder=no,ffmpeg=no,mkv=no --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --ytdl-raw-options="cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING" --ytdl-format="$VIDEOQUALITYPARM" --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
        else
	        mpv --msg-level=cplayer=no,display-tags=no,recorder=no,ffmpeg=no,mkv=no --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --ytdl-raw-options="ignore-config=,cookies-from-browser=$BROWSERAPP+$BROWSERKEYRING" --ytdl-format="$VIDEOQUALITYPARM" --no-config --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
        end
      end
    end
  else  
    if test -n "$SUBS" 
      if set -ql _flag_verbose
        if test "$AUTOSUBS" = "yes"
          if test "$ALLOWCFG" = "yes"
	          mpv -v --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="write-subs=,write-auto-sub=" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          else
	          mpv -v --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="ignore-config=,write-subs=,write-auto-sub=" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --no-config --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          end
        else
          if test "$ALLOWCFG" = "yes"
	          mpv -v --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="write-subs=" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          else
	          mpv -v --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="ignore-config=,write-subs=" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --no-config --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          end
        end
      else
        if test "$AUTOSUBS" = "yes"
          if test "$ALLOWCFG" = "yes"
	          mpv --msg-level=cplayer=no,display-tags=no,recorder=no,ffmpeg=no,mkv=no --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="write-subs=,write-auto-sub=" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          else
	          mpv --msg-level=cplayer=no,display-tags=no,recorder=no,ffmpeg=no,mkv=no --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="ignore-config=,write-subs=,write-auto-sub=" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --no-config --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          end
        else
          if test "$ALLOWCFG" = "yes"
	          mpv --msg-level=cplayer=no,display-tags=no,recorder=no,ffmpeg=no,mkv=no --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="write-subs=" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          else
	          mpv --msg-level=cplayer=no,display-tags=no,recorder=no,ffmpeg=no,mkv=no --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --slang="$SUBS" --sub-auto=fuzzy --ytdl-raw-options="ignore-config=,write-subs=" --ytdl-raw-options-add=sub-lang="[$(echo $SUBS)]" --ytdl-raw-options-append="abort-on-error=" --ytdl-format="$VIDEOQUALITYPARM" --no-config --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
          end
        end
      end
    else
      if set -ql _flag_verbose
        if test "$ALLOWCFG" = "yes"
	        mpv -v --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --sub-auto=no --sub-visibility=no --ytdl-format="$VIDEOQUALITYPARM" --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
        else
	        mpv -v --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --sub-auto=no --sub-visibility=no --ytdl-raw-options="ignore-config=" --ytdl-format="$VIDEOQUALITYPARM" --no-config --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
        end
      else
        if test "$ALLOWCFG" = "yes"
	        mpv --msg-level=cplayer=no,display-tags=no,recorder=no,ffmpeg=no,mkv=no --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --sub-auto=no --sid=no --sub-visibility=no --ytdl-format="$VIDEOQUALITYPARM" --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
        else
	        mpv --msg-level=cplayer=no,display-tags=no,recorder=no,ffmpeg=no,mkv=no --ytdl=yes --stream-record="$SAVEAS" --screen="$SCREEN" --fullscreen="$FULLSCREEN" --cache="$CACHE" --demuxer-lavf-o="http_persistent=0" --demuxer-max-bytes="$DEMUXSIZE" --demuxer-max-back-bytes="$DEMUXBACKSIZE" --cache-secs="$SECSSIZE" --sub-auto=no --sid=no --sub-visibility=no --ytdl-raw-options="ignore-config=" --ytdl-format="$VIDEOQUALITYPARM" --no-config --profile="$PROFILE" --hwdec="$HWDEC" --gpu-context="$GPUCTX" --gpu-api="$GPUCTX" --vo="$VO" --ao="$AO" --vf="$VF" --af="$AF" --user-agent="$USER_AGENT" (echo $URL)
        end
      end
    end
  end

  if test $status -eq 0
    if test "$USE_LOGGING" = "yes"
      echo "$VIDEOTEXT" >> ~/tubeslog.txt
      echo "$URLTEXT" >> ~/tubeslog.txt
      echo "$CHANNELTEXT" >> ~/tubeslog.txt
      echo "$DATETEXT" >> ~/tubeslog.txt
      echo " " >> ~/tubeslog.txt
    end
  end

  for funk in date grep pbpaste
    functions --erase $funk
  end

end
