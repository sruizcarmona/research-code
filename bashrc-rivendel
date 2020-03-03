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
#test -s ~/.alias && . ~/.alias || true

#DUCK
export MOE_SVL_LOAD='/home/sergi/work/JOCS_SVL'
export PATH=$RBT_ROOT/bin:/home/sergi/work/scripts:/home/sergi/work/scripts/R/:/home/sergi/work/scripts/utils/:/home/sergi/work/scripts/utils/collect_jarz/:$PATH

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

#alias sdsort='/usr/local/bin/sdsort'
#alias sdfilter='/usr/local/bin/sdfilter'
#alias sdreport='/usr/local/bin/sdreport'

#### OPENBABEL
#===========
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mds/sergi/openbabel-2.3.2/INSTALLATION/lib
#export BABEL_DATADIR=/usr/local/openbabel-2.2.3/data
#export PYTHONPATH=/mds/sergi/openbabel-2.3.2/INSTALLATION/lib:$PYTHONPATH
#export PATH=/mds/sergi/openbabel-2.3.2/INSTALLATION/bin/:$PATH
## GRID
## ====
####CHANGE AFTER INSTALLING
#source /usr/local/grid/env_grid.sh

## AMBER
## ======
##alias ambpdb='/usr/local/amber9/exe/ambpdb'

## Modules stuffs
## ==============
#source /usr/share/modules/init/bash

#PYMOL
#alias pymol=/home/sergi/Programs/pymol/pymol

###uncomment this after installing!!!
## PYTHONPATH
#module load biskit

## MOE Tokens
#module load moe

####OWN ALIAS AND EXPORTS
alias ls='ls --color'
alias marc='ssh sruiz@161.116.138.71 -p 31415'
alias teckel='ssh sergi@girona.far.ub.es'
alias pulp='ssh -p 31415 sergi@pulp'
alias logtowho='ssh sruiz@161.116.33.125 -p 31415'
alias lñ='ls -lrth'
alias lr='ls -lrth'
alias topS='top -u sergi -d 1 -c'
#alias getRBDPRMfile='cp $SCRIPTS/rdock/createRBDPRMfile.py $SCRIPTS/rdock/template.prm .'
alias sourcealias='source ~/.bashrc'
alias vialias='vi ~/.bashrc'
alias op='xdg-open'
alias beckman='ssh -p 31415 sruiz@beckman'
alias eggplant='ssh -p 31415 sergi@eggplant'
alias curry='ssh -p 31415 sergi@curry'
alias checklicmoe='$MOEHOME/bin/lmutil lmstat -c $MOEHOME/license.dat -f'
alias minotauro='ssh ub63408@mt1.bsc.es'
alias minotauroXB='ssh ub63899@mt1.bsc.es'
alias minotauroDA='ssh ub63221@mt1.bsc.es'
alias plotsPtraj5='for file in WAT_1/*txt; do gracebat W*/`basename $file` -world [0 0 100000 5]; done;for file in *.ps; do convert -rotate 90 $file `basename $file .ps`_y5.png; done;rm *_*.ps'
alias plotsPtraj5Common='cd common_ref/; for file in ../WAT_0/common_ref/*txt; do gracebat ../W*/common_ref/`basename $file` -world [0 0 100000 5]; done;for file in *.ps; do convert -rotate 90 $file `basename $file .ps`_y5.png; done;rm *_*.ps; cd ../'
alias plotsPtraj10='for file in WAT_1/*txt; do gracebat W*/`basename $file` -world [0 0 100000 10]; done;for file in *.ps; do convert -rotate 90 $file `basename $file .ps`_y10.png; done;rm *_*.ps'
alias plotsPtraj='for file in WAT_1/*txt; do gracebat W*/`basename $file`; done;for file in *.ps; do convert -rotate 90 $file `basename $file .ps`.png; done;rm *_*.ps'
alias dssp='/home/sergi/Programs/dssp/dssp-2.0.4-linux-amd64'
alias plotsPtrajPierre='for file in WAT_1/pierre_rms/rms_*pierre.txt; do gracebat W*/pierre_rms/`basename $file` -world [0 0 100000 5]; done;for file in *.ps; do convert -rotate 90 $file pierre_`basename $file .ps`.png; done;rm *_*.ps'
alias sshzar='ssh ub13076@caesar.bifi.unizar.es'
alias rmEmpty='find . -size 0 -delete'
alias myR='/home/sergi/work/SOFT/R/bin/R'

###FUNCTIONS

scptomarc(){
        scp -P 31415 -r $1 sruiz@marc:$2
}

scpmino(){
        scp -r $1 pr1e1303@mt1.bsc.es:$2
}

rsyncmarc(){
        rsync -av -e "ssh -p 31415" $1 sruiz@marc:$2
}

rsyncfrommarc(){
        rsync -av -e "ssh -p 31415" sruiz@marc:$1 $2
}

PS1='\[\033[38;5;107m\][\u@\h \W]\$\[\e[0m\] '

#echo "--" >> ~/kkpath
#echo $PATH >> ~/kkpath

source /home/sergi/miniconda3/etc/profile.d/conda.sh
