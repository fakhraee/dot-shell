# ls
function l
  ls++ --group-directories-first $argv
end
function ll
  l --potsf $argv
end
function la
  l -a
end
function lla
  ll -a
end


# ssh
function ssh
  command ssh -o ServerAliveInterval=60 $argv
end
function vssh -d ''
  if test -z $argv[1]
    $EDITOR $HOME/.ssh/config
  else
    $EDITOR $HOME/mnt/cry/ssh/config.d/$argv[1]
  end
end
function sshfw -d ''
  if test -z "$argv"
    begin
      echo \
        local:\v$_ -m l -r to_remote:on_port -l local:port\n\
        \bremote:\v$_ -m r -f -r from_remote:on_port -l local:port
      return
    end
  end
  set -l options 'm/mode=' 'r/remote=' 'l/local=' 'f/fork'
  argparse -n sshfw $options -- $argv
  set -q _flag_mode; and set mode $_flag_mode; or return
  set remote $_flag_remote
  set local $_flag_local
  set remote_host (string split -m1 : $remote | head -1)
  set remote_port (string split -m1 : $remote | tail -1)
  set local_host (string split -m1 : $local | head -1)
  set local_port (string split -m1 : $local | tail -1)
  if test $mode = "l"
    set vmode local forwarding:
    set cmd ssh -NL $local_port:$local_host:$remote_port \
                -F $HOME/.ssh/config $remote_host
  else if test "$mode" = "r"
    set vmode remote forwarding:
    set cmd ssh -NR $remote_port:$_flag_local \
                -F $HOME/.ssh/config $remote_host
  else
    echo valid modes are: l or r; and return
  end
  if set -q _flag_fork
      set cmd $cmd -fn; and set cmd $cmd
  else
    echo $vmode $cmd
  end
  eval ($cmd)
  pgrep -f "ssh.*$remote_host"
end


# vcsh
function v
  vcsh $argv
end
function vs
 v status | egrep -B1 M
end
function vls
  v list
end
function vrs
  v $argv reset --hard
end


# aud
function sndl -d 'download from soundcloud'
  mpv --ao=pcm --ao-pcm-file=$argv[2] $argv[1]
  lame $argv[2] && rm $argv[2]
end
function mp3it -d 'get file and convert it to mp3'
  set -l options 'r/remove'
  argparse -n mp3it $options -- $argv; or begin echo unknown option; and return; end
  set input $argv[1]
  set input_splitted (string split -r -m 1 . $input | head -1)
  set output $argv[2].wav
  test -z $output; and set output $input_splitted.wav
  begin
    mpv --ao=pcm --ao-pcm-file=$output --no-video $input; or \
    mplayer -quiet -ao pcm:file=$output -vo null $input
  end; and lame $output; and command rm $output
  set -q _flag_remove; and command rm $input; and echo $input removed
end
function song -d 'current mpd playing song'
  notify-send \
    -u normal -t 5000 --hint=int:transient:1 \
    "Now Playing" (mpc --host=$HOME/var/lib/mpd/socket current) 2>&1
end


# aliases
function e
  nvim $argv
end
function rm
  command rm -i $argv
end
function diff
  colordiff $argv
end
function dush
  du -csh *|sort -h
end
function less
  command less -FX $argv
end
function scl
  sudo systemctl $argv
end
function scsv
  curl -L http://git.io/unix
end
function i3l
  i3lock -n -f -c 000000
end
function ii3l
  i3lock -n -f -i "$HOME/.config/i3/bsod.png"
end
function ub
  udisksctl mount -b $argv
end
function trj
  $HOME/bin/trans -t fa $argv
end
function wtt
  curl wttr.in/mashhad
end
function ly
  setxkbmap -layout us,ir -option grp:ctrls_toggle,caps:escape
end
function lightup
  xbacklight -inc 10
end
function lightdown
  xbacklight -dec 10
end
function swapmouse
  xmodmap -e "pointer = 3 2 1"
end
function m
  . /usr/lib/mc/mc-wrapper.sh
end
function ports
  netstat -tulnap
end
function dg
  dig +{,no}short $argv
end
function pyweb
  hostname -I && python -m SimpleHTTPServer
end
function axl
  axel -a -n 8 $argv
end
function pgg
  ping google.com
end
function p9
  ping 9.9.9.9
end
function sagent
  eval (ssh-agent -s)
end
function mutt
  neomutt -F ~/.config/neomutt/neomuttrc
end
function syslog -d 'always monitoring syslog'
  sudo grc xtail /var/log/syslog
end


# docker
function dkp
  docker pull $argv
end
function dkr
  docker run --rm $argv
end
function dks
  docker stop $argv
end
function dkps
  docker ps -a --format "{{.ID}}; {{.Names}}; {{.Ports}}; {{.Status}}; {{.Image}}. {{.Size}}"
end
function dki
  docker images -a --format "{{.ID}}; {{.Repository}}; {{.Tag}}; {{.Size}}"
end


# neovim
function nv -d 'neovim'
  nvim $argv
end
function nvs -d 'shell in nvim'
  nvim -c 'Deol'
end


#
function virsh -d 'wrapper around virsh'
  set -l options 'r/remote=' 's/session'
  argparse -n virsh $options -- $argv; or begin echo unknown option; and return; end
  set driver qemu://
  set host ''
  set path system
  set -q _flag_remote; and set host $_flag_remote; and set driver qemu+ssh://
  set -q _flag_session; and set path session
  command virsh -c $driver$host/$path $argv
end


function gdiffr -d 'send git diff to remote server'
  git diff | ssh $argv[1] 'cat - >/tmp/.gdiffr'
end


function unuker -d 'purge unused kernels and headers'
  set kv (uname -r | awk -F- '{print $1"-"$2}')
  sudo aptitude purge \
    "?installed?or(linux-headers-[0-9],linux-image-[0-9]) ?installed?not($kv)"
end


function wgetr -d 'wget recursive'
  wget --no-directories --recursive --level=1 --execute robots=off $argv[1]
end


function fin -d 'find sth in smw'
  find "$argv[2]" -iname "*"$argv[1]"*"
end
