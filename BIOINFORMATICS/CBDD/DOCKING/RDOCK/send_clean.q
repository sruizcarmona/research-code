#!/bin/bash
#SBATCH -p sysgen                #Partition: 'Short' (<24h) or 'Long' (>24h)
#SBATCH --job-name=VS_SPECS_gpx1_model1.prm
#SBATCH --nodes=1
#SBATCH --ntasks=1             # Max n of tasks/CPU cores used by the job:
#SBATCH --cpus-per-task=1
###SBATCH --ntasks-per-node=8
#SBATCH --mem=100000            # The amount of mem in mb/process in the job:
#SBATCH --time=1-00:0:00        # max time of the job in days-hours:mins:sec
# The job command(s):

date

#sorting all pre-sorted files 
cat ./out/*_sorted.sd | sdsort -n -f'SCORE.INTER' | sdfilter -f'$_COUNT == 1' > specs_raw_hits.sd
echo Each block of consecutive records per ligand have been presorted by SCORE ready for filtering and manual inspection

#log files
echo Packing log files in log_files_raw.tar.gz...
tar -czf log_files_raw.tar.gz log/
echo DONE
#sd files
echo Packing all SD files in out_files_raw.tar.gz...
tar -czf out_files_raw.tar.gz out/
echo DONE
echo You may now safely remove the ./log/ and ./out/ directories if you wish to save disk space

date
