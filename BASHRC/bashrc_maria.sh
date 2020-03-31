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

export MSMSSERVER=/usr/local/bin/msms.x86_64Linux2.2.6.1
export AMBERHOME=/mds/sergi/amber12
export PATH=$AMBERHOME/bin:$PATH
#export AMBERHOME=/usr/local/amber9/
#export PATH=/usr/local/amber9/exe:$PATH

export MOE='/mds/sergi/moe2018/'
alias moebatch=$MOE/bin/moebatch
alias moe=$MOE/bin/moe
#export MOE_SVL_LOAD='/mds/sergi/HSP90_JOCS/JOCS_MOE/JOCS_SVL'
export MOE_SVL_LOAD='/home/sergi/work/dev/duck_dev/duck'

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

#alias sdsort='/usr/local/bin/sdsort'
#alias sdfilter='/usr/local/bin/sdfilter'
#alias sdreport='/usr/local/bin/sdreport'

#### OPENBABEL 
#===========
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mds/sergi/openbabel-2.3.2/INSTALLATION/lib
#export BABEL_DATADIR=/usr/local/openbabel-2.2.3/data
export BABEL_DATADIR=/mds/sergi/openbabel-2.3.2/data
#export PYTHONPATH=/mds/sergi/openbabel-2.3.2/INSTALLATION/lib:$PYTHONPATH
#export PYTHONPATH=/usr/local/lib:$PYTHONPATH
export PYTHONPATH=/usr/local/lib
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

export SCHRODINGER=/mds/sergi/schrodinger2013
export SCHROD_LICENSE_FILE=1715@sdf1.cesca.cat
export PATH=$PATH:$SCHRODINGER
export PYMOL4MAESTRO=/home/sergi/Programs/pymol/

###uncomment this after installing!!!
## PYTHONPATH
#module load biskit

## MOE Tokens
#module load moe

####OWN ALIAS AND EXPORTS
alias marc='ssh sruiz@161.116.138.71 -p 31415'
alias teckel='ssh sergi@girona.far.ub.es'
alias pulp='ssh -p 31415 sergi@pulp'
alias rivendel='ssh -p 31415 sergi@rivendel'
alias logtowho='ssh sruiz@whonas -p 31415'
alias maestro='$SCHRODINGER/maestro'
alias sdconvert='$SCHRODINGER/utilities/sdconvert'
alias canvasSearch='$SCHRODINGER/utilities/canvasSearch'
alias mol2convert='$SCHRODINGER/utilities/mol2convert'
alias pdbconvert='$SCHRODINGER/utilities/pdbconvert'
alias structconv='$SCHRODINGER/utilities/structconvert'
alias GlideIn='python ~/work/scripts/createGlideIn.py'
alias GridIn='python ~/work/scripts/createGridIn.py'
alias scripts='cd $SCRIPTS'
alias fpocket='~/Programs/fpocket2/bin/fpocket'
alias lñ='ls -lrth'
alias lr='ls -lrth'
alias getRBDockFiles='cp $SCRIPTS/rdock/* .'
alias topS='top -u sergi -d 1 -c'
#alias getRBDPRMfile='cp $SCRIPTS/rdock/createRBDPRMfile.py $SCRIPTS/rdock/template.prm .'
alias sourcealias='source ~/.bashrc'
alias vialias='vi ~/.bashrc'
alias prepDocking='$SCRIPTS/rdock/prepDockGrids_DUDe.sh'
alias op='xdg-open'
alias beckman='ssh -p 31415 sruiz@beckman'
alias eggplant='ssh -p 31415 sergi@eggplant'
alias curry='ssh -p 31415 sergi@curry'
alias checklicmoe='/mds/sergi/moe2014/bin/lmutil lmstat -c /mds/sergi/moe2014/license.dat -f'
alias grep='grep --color'
alias scrass='/mds/sergi/screeningassistant/sa/bin/sa'
alias adt='/mds/sergi/MGLTools-1.5.6rc2/bin/adt'
alias preprecVina='/mds/sergi/MGLTools-1.5.6rc2/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_receptor4.py'
alias prepligVina='/mds/sergi/MGLTools-1.5.6rc2/MGLToolsPckgs/AutoDockTools/Utilities24/prepare_ligand4.py'
alias minotauro='ssh ub63408@mt1.bsc.es'
alias minotauroXB='ssh ub63899@mt1.bsc.es'
alias minotauroDA='ssh ub63221@mt1.bsc.es'
alias minotauroAX='ssh ub79753@mt1.bsc.es'
alias minotauroGG='ssh ub63657@mt1.bsc.es'
alias minotauroMM='ssh ub63724@mt1.bsc.es'
alias minotauroMR='ssh ub63865@mt1.bsc.es'
alias marenostrumMM='ssh ub63724@mn1.bsc.es'
alias marenostrumXB='ssh ub63899@mn1.bsc.es'
alias marenostrum='ssh ub63408@mn1.bsc.es'
alias aggrescan='/home/sergi/work/AGGREGATION/soft/aggrescan/aapc_sergiruizcarmona.i386'
alias knime='~/Programs/knime_2.7.4/knime'
alias plotsPtraj5='for file in WAT_1/*txt; do gracebat W*/`basename $file` -world [0 0 100000 5]; done;for file in *.ps; do convert -rotate 90 $file `basename $file .ps`_y5.png; done;rm *_*.ps'
alias plotsPtraj5Common='cd common_ref/; for file in ../WAT_0/common_ref/*txt; do gracebat ../W*/common_ref/`basename $file` -world [0 0 100000 5]; done;for file in *.ps; do convert -rotate 90 $file `basename $file .ps`_y5.png; done;rm *_*.ps; cd ../'
alias plotsPtraj10='for file in WAT_1/*txt; do gracebat W*/`basename $file` -world [0 0 100000 10]; done;for file in *.ps; do convert -rotate 90 $file `basename $file .ps`_y10.png; done;rm *_*.ps'
alias plotsPtraj='for file in WAT_1/*txt; do gracebat W*/`basename $file`; done;for file in *.ps; do convert -rotate 90 $file `basename $file .ps`.png; done;rm *_*.ps'
alias dssp='/home/sergi/Programs/dssp/dssp-2.0.4-linux-amd64'
alias plotsPtrajPierre='for file in WAT_1/pierre_rms/rms_*pierre.txt; do gracebat W*/pierre_rms/`basename $file` -world [0 0 100000 5]; done;for file in *.ps; do convert -rotate 90 $file pierre_`basename $file .ps`.png; done;rm *_*.ps'
alias abpa='/home/sergi/Programs/abpa/bin/abpa'
alias bluej='/home/sergi/Programs/bluej/bluej &'
alias sshzar='ssh ub13076@caesar.bifi.unizar.es'
alias rmEmpty='find . -size 0 -delete'
alias pizdaint='ssh sruiz@ela.cscs.ch'
alias plotsPTRAJrmsdTET2='for f in LIG ZN FE OGA DNA; do echo $f; gracebat $f\rmsd_WAT_* -world [0 0 100000 10]; convert -rotate 90 $f\rmsd*.ps $f\_RMSD.png; rm $f\rmsd*.ps; rm Untitled.ps;  done'
alias plotsPTRAJdistTET2='for f in dist3d_LIG*WAT_1.txt; do b=`basename $f _WAT_1.txt`; echo $b; gracebat $b\_WAT_*txt -world [0 0 100000 10]; convert -rotate 90 $b\*.ps $b\_DIST.png; rm $b\_*.ps; done'
alias mountXPEOPLE='sshfs -p 31415 sruiz@marc:. /home/sergi/XPEOPLE/'
alias qstatINFO='squeue | awk '\''{print $1}'\'' | grep -vi JOBID | xargs -n 1 scontrol show jobid -dd | grep Command'

export RBT_ROOT=/home/sergi/work/dev/rdock/rDock_2013.1_140909
export PATH=$RBT_ROOT/bin:/home/sergi/work/scripts:/home/sergi/work/scripts/R/:/home/sergi/work/scripts/utils/:/home/sergi/work/scripts/utils/collect_jarz/:$PATH
export LD_LIBRARY_PATH=$RBT_ROOT/lib:$LD_LIBRARY_PATH
export SCRIPTS='/home/sergi/work/scripts'
alias sdrmsd='~/work/dev/rdock/rdock_svn/bin/sdrmsd'

#Libreoffice 4.1
alias oocalc="/opt/libreoffice4.1/program/soffice --calc"
alias oowriter="/opt/libreoffice4.1/program/soffice --writer"
alias ooimpress="/opt/libreoffice4.1/program/soffice --impress"

#PYTHON
export PATH=/home/sergi/.local/bin:$PATH
#export PYTHONPATH=$PYTHONPATH:/mds/sergi/programs-bin/lib64/python2.7/site-packages
#export PYTHONPATH=$PYTHONPATH:/mds/sergi/programs-bin/lib/python2.7/site-packages

#RDKit
export PYTHONPATH=$PYTHONPATH:/mds/sergi/programs-bin/rdkit
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mds/sergi/programs-bin/rdkit/lib


#VMD
export PATH=/mds/sergi/vmd/bin:$PATH
#CHIMERA
export PATH=/mds/sergi/chimera/bin:$PATH
#NETBEANS
export PATH=/mds/sergi/netbeans-6.9.1/bin:$PATH
#autodock vina
export PATH=/mds/sergi/autodock_vina/bin:$PATH
#export PAT=/mds/sergi/MGLTools-1.5.6rc2/bin:$PATH
#NACCESS
export PATH=/home/sergi/Programs/naccess2.1.1/:$PATH
#Marvin
export PATH=/mds/sergi/ChemAxon/bin:$PATH
#agentcell
export PATH=/home/sergi/Programs/stochsim/bin:$PATH
#Gaussian
alias g09="/mds/sergi/g09/g09"
export GAUSS_EXEDIR="/mds/sergi/g09/"

##CDBM
export CDBM=/mds2/sergi/SA/CDBM.pl

#ANDROID
export JAVA_HOME=/home/sergi/Programs/jdk1.7.0_67

#htmd
#export PATH=$PATH:/mds/sergi/miniconda3/bin

#latex2rtf
export PATH=$PATH:/home/sergi/work/dev/bin

#mdcons
export PATH=$PATH:/home/sergi/Programs/mdcons-src-2.0/bin:/home/sergi/Programs/mdcons-src-2.0/scripts

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

cdd(){
	cd *$1*
}

sdcount(){
	grep -c '\$\$\$\$' $1
}

getligs(){
	cp $1 test.mae.gz
	gunzip test.mae.gz
	perl /home/sergi/work/scripts/getLigands.pl test.mae > ligands.txt
	rm test.mae	
}

getligsMOL2(){
	cp $1 test.mae.gz
	gunzip test.mae.gz
	perl /home/sergi/work/scripts/getLigandsMOL.pl test.mae > ligands.txt
	rm test.mae	
}

waltz(){
	/home/sergi/work/AGGREGATION/soft/waltz/waltz.pl $1 /home/sergi/work/AGGREGATION/soft/waltz/616.mat $2
}

getligsSD(){
	sdreport -t -nh $1 | awk '{print $2}'
}

sd_cluster_info(){
	sdreport -t'$CLUSTER_85_ID,$CLUSTER_85_meansim_withincluster,$CLUSTER_85_Population,SCORE.INTER' $1 | grep -e $2.000 -e SCORE
}

PS1='\[\e[0;36m\][\u@\h \W]\$\[\e[0m\] '

#echo "--" >> ~/kkpath
#echo $PATH >> ~/kkpath

############
# ips farmacia
###########
#161.116.70.211  maria maria
#161.116.70.212  curry curry
#161.116.138.71  marc marc
#161.116.138.74  beckman beckman
#161.116.70.209  eggplant eggplant
#161.116.70.208  pulp pulp
#161.116.33.125  nas nas
#161.116.33.195  guillermo euterpe curry
#161.116.33.33   sergi maria
#161.116.33.196  rivendel marina
#161.116.33.197  pulp serena
#161.116.33.195  curry curry
#161.116.93.102  eggplant morena
#161.116.33.33   maria maria
#161.116.94.210  orbital miriam
#161.116.94.193  maciej maciej
#161.116.94.194  moira terpsichore
#161.116.33.105  utopia utopia
#161.116.33.162  salvo salvo
#161.116.93.59   talia emilio
##############################
