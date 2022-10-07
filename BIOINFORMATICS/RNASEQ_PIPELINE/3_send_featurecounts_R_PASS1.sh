#!/bin/bash
#Partition: 'Short' (<24h) or 'Long' (>24h)
#SBATCH -p sysgen
#Give the job a name:
#SBATCH --job-name="fcounts"
# Maximum number of tasks/CPU cores used by the job:
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
# The amount of memory in megabytes per process in the job:

# The maximum running time of the job in days-hours:mins:sec
#SBATCH --time=0-12:0:00
# The job command(s):


source /home/sruizcarmona/miniconda3/etc/profile.d/conda.sh
conda activate bio_rnaseq

# ERROR IN SLURM, RUN NEXT LINE WITH INTERACTIVE SESSION
# for both pass1 and 2
R CMD BATCH featurecounts_R_PASS1.r
#R CMD BATCH featurecounts_R_PASS2.r
#Rscript featurecounts_R.r
