#!/bin/bash

#SBATCH --job-name="dna2prot"	#Give the job a name:
#SBATCH --output=restart_%J.out
#SBATCH --error=restart_%J.err
##SBATCH --array=0-9
#SBATCH -p sysgen,sysgen_long		#Partition: 'Short' (<24h) or 'Long' (>24h)
#SBATCH --nodes=1
#SBATCH --ntasks=32		# Max n of tasks/CPU cores used by the job:
###SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=1-0:0:00 	# max time of the job in days-hours:mins:sec
# The job command(s):

# Print the task id.
#echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID
#echo slurm jobid: $SLURM_ARRAY_JOB_ID

source /home/sruizcarmona/miniconda3/etc/profile.d/conda.sh
conda activate bioinfo-modeller

export GREASY_NWORKERS=20
export GREASY_LOGFILE=greasyarray_restart_${SLURM_JOB_ID}.log
/home/sruizcarmona/SOFT/greasy/bin/greasy greasy_DNA2PROT_split_00.txt-undefined.rst
