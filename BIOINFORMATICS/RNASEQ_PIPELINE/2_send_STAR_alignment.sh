#!/bin/bash
#Partition: 'Short' (<24h) or 'Long' (>24h)
#SBATCH -p sysgen_long
#Give the job a name:
#SBATCH --job-name="STAR_Mapping"
# Maximum number of tasks/CPU cores used by the job:
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#The amount of memory in megabytes per process in the job:
#SBATCH --mem=100g
# The maximum running time of the job in days-hours:mins:sec
#SBATCH --time=3-0:0:00
# The job command(s):

source /home/sruizcarmona/miniconda3/etc/profile.d/conda.sh
conda activate bio_rnaseq

export GREASY_NWORKERS=6
date
~/SOFT/greasy/bin/greasy greasy_star_unmerged.txt
date
