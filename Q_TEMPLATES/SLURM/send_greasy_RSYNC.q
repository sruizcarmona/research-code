#!/bin/bash -l
#SBATCH -p sysgen,sysgen_long               #Partition: 'Short' (<24h) or 'Long' (>24h)
#SBATCH --job-name=rsync
#SBATCH --nodes=1
#SBATCH --ntasks=1             # Max n of tasks/CPU cores used by the job:
#SBATCH --cpus-per-task=4
###SBATCH --ntasks-per-node=8
#SBATCH --mem=10            # The amount of mem in mb/process in the job:
#SBATCH --time=3-00:0:00        # max time of the job in days-hours:mins:sec
#####################################
# The job command(s):

export GREASY_NWORKERS=4

#for f in WORK/*; do echo rsync -av $f /sysgen/workspace/users/sruizcarmona/WORK/ ">" rsync_`basename $f`.log; done | grep -v DNA >  greasy_rsync_WORK.txt
for f in WORK/*; do echo rsync -av $f /sysgen/workspace/users/sruizcarmona/WORK/ ">" rsync_`basename $f`.log; done >  greasy_rsync_WORK.txt

date
~/SOFT/greasy/bin/greasy greasy_rsync_WORK.txt
date
