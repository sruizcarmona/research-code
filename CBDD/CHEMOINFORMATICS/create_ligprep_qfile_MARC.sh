#!/bin/sh
file=$1
LOGPATH=$2
moltype=$3

echo "#!/bin/sh
#$ -N ligprep_CDBM
#$ -S /bin/sh
#$ -q serial
#$ -o $LOGPATH/${file%%.$moltype}.dat
#$ -e $LOGPATH/${file%%.$moltype}.err
#$ -l h=\"syrah|garnatxa|klimt|dali\"
#$ -cwd

module load schrodinger2013
# These are the comands to be executed.

b=\`basename $file .$moltype\`

ligprep -ma 300 -s 8 -t 6 -i 2 -W i,-ph,7.0,-pht,1.0 -i$moltype $file -osd \$b\_output.sdf -WAIT
" > qsubtmp.txt

mv qsubtmp.txt qsub_${file%%.$moltype}.sh

