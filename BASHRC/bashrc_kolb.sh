# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200

#echo $PATH


test -s ~/.alias && . ~/.alias || true


## Who is using MOE (in pluto) and executing as root
#  ./bin/lmgrd -c /home/soft/moe/license.dat -l /home/soft/moe/lmgrd.log


# rdock
#setenv RBT_ROOT /home/soft/rdock/2006.1
#setenv PATH ${PATH}:${RBT_ROOT}/bin
#if ($?LD_LIBRARY_PATH) then
#   setenv LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${RBT_ROOT}/lib
#else
#   setenv LD_LIBRARY_PATH ${RBT_ROOT}/lib
#endif

## DOCKING 
#=========

####OWN ALIAS AND EXPORTS
alias marc='ssh sruiz@161.116.138.71 -p 31415'
#alias ls='ls --color=auto'
alias ll='ls -l'
alias lñ='ls -lrth'
alias lr='ls -lrth'
alias topS='top -u sergi -d 1 -c'
alias sourcealias='source ~/.bash_profile'
alias vialias='vi ~/WORK/bashrc'
alias op='xdg-open'
alias grep='grep --color'
alias rmEmpty='find . -size 0 -delete'
alias myR='/home/sr828/SOFT/R/bin/R'
alias mn='ssh ub63408@mn1.bsc.es'

#export AMBERHOME=/home/sr828/SOFT/amber16/
#test -f /home/sr828/SOFT/amber16//amber.sh && source /home/sr828/SOFT/amber16//amber.sh
#export PATH=$PATH:$AMBERHOME/bin

#htseq
export PATH=$PATH:/home/sr828/ucc-fileserver/SOFT/bowtie2-2.3.3/

#PS1='\[\e[0;93m\][\u@\h \W]\$\[\e[0m\] '
#PS1='\[\e[0;93m\][\u@\h: \e[37;1m\W\e[0;93m]\$\[\e[0m\] '
PS1='\[\e[0;92m\][\u@\h: \[\e[37;1m\]\W\[\e[0;92m\]]\$\[\e[0m\] '
