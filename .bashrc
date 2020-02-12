#!/bin/bash

#================================================
# .bash_history
#================================================

#------------------------------------------------
# Erase duplicates
#------------------------------------------------
export HISTCONTROL=erasedups

#------------------------------------------------
# resize history size
#------------------------------------------------
export HISTSIZE=20000


#------------------------------------------------
# append to bash_history if Terminal.app quits
#------------------------------------------------
shopt -s histappend


#================================================
# Bash Auto complete
#================================================
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'




#================================================
# Command Aliases
#================================================


#------------------------------------------------
# VI
#------------------------------------------------
alias vi='gvim'
alias vim='gvim'

#------------------------------------------------
# disk usage in human format
# with total at the end
#------------------------------------------------
alias df="df -Tha --total"


#------------------------------------------------
# disk usage in human format
# with total at the end
#------------------------------------------------
alias du="du -ach | sort -h"


#------------------------------------------------
# Mkdir Alias
#------------------------------------------------
alias mkdir="mkdir -pv"


#------------------------------------------------
# top as htop 
#------------------------------------------------
alias top="htop"


#------------------------------------------------
# Make file operations interactive
#------------------------------------------------
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'


#-------------------------------------------------------------
# Spelling typos - highly personnal and keyboard-dependent :-)
#-------------------------------------------------------------

alias xs='cd'
alias vf='cd'
alias moer='more'
alias moew='more'
alias kk='ll' 
alias cler='clear'
alias celr='clear'
alias cear='clear'
alias celar='clear'
alias clr='clear'
alias claer='clear'
alias clar='clear'


#-------------------------------------------------------------
# Add colors for filetype and  human-readable sizes by default 
# on 'ls':
#-------------------------------------------------------------
alias ls='ls -h --color'
alias lx='ls -lXB'         #  Sort by extension.
alias lk='ls -lSr'         #  Sort by size, biggest last.
alias lt='ls -ltr'         #  Sort by date, most recent last.
alias lc='ls -ltcr'        #  Sort by/show change time,most recent last.
alias lu='ls -ltur'        #  Sort by/show access time,most recent last.


#-------------------------------------------------------------
# The ubiquitous 'll': directories first, with alphanumeric sorting:
#-------------------------------------------------------------
alias ll="ls -lv --group-directories-first"
alias lm='ll |more'        #  Pipe through 'more'
alias lr='ll -R'           #  Recursive ls.
alias la='ll -A'           #  Show hidden files.
alias tree='tree -Csuh'    #  Nice alternative to 'recursive ls' ...


#-------------------------------------------------------------
# Pretty-print of some PATH variables:
#-------------------------------------------------------------
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'


#-------------------------------------------------------------
# Add color to grep
#-------------------------------------------------------------
alias grep='grep -n --color'

#-------------------------------------------------------------
# Search history
#-------------------------------------------------------------
alias ghist='history | grep $1'





#================================================
# Path aliases
#================================================
export workspace='add your own path here'
export WORKSPACE='add your own path here'
export code='add your own path here'
export CODE='add your own path here'





#================================================
# Custom functions 
#================================================

#-------------------------------------------------------------
# Extract
#-------------------------------------------------------------
function extract {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
    return 1
 else
    for n in $@
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar) 
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *)
                         echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

#-------------------------------------------------------------
# Creates an archive (*.tar.gz) from given directory.
#-------------------------------------------------------------
function maketar() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }

#-------------------------------------------------------------
# Create a ZIP archive of a file or folder.
#-------------------------------------------------------------
function makezip() { zip -r "${1%%/}.zip" "$1" ; }

#-------------------------------------------------------------
# Make your directories and files access rights sane.
#-------------------------------------------------------------
function sanitize() { chmod -R u=rwX,g=rX,o= "$@" ;}





#-------------------------------------------------------------
# File & strings related functions:
#-------------------------------------------------------------


#-------------------------------------------------------------
# Find a file with a pattern in name:
#-------------------------------------------------------------
function ff() { find . -type f -iname '*'"$*"'*' -ls ; }

#-------------------------------------------------------------
# Find a file with pattern $1 in name and Execute $2 on it:
#-------------------------------------------------------------
function fe() { find . -type f -iname '*'"${1:-}"'*' \
-exec ${2:-file} {} \;  ; }

#-------------------------------------------------------------
#  Find a pattern in a set of files and highlight them:
#+ (needs a recent version of egrep).
#-------------------------------------------------------------
function fstr()
{
    OPTIND=1
    local mycase=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
           i) mycase="-i " ;;
           *) echo "$usage"; return ;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | \
xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more

}

#-------------------------------------------------------------
# Swap 2 filenames around, if they exist (from Uzi's bashrc).
#-------------------------------------------------------------
function swap()
{ 
    local TMPFILE=tmp.$$

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}


