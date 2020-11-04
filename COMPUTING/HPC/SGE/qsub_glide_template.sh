#!/bin/sh
###########################################################
# USAGE:                                                  #
# qsub queue_whatever.csh to submit a job                 #
# qstat to monitorize your jobs                           #
# qstat -f to see an overview of the queues               #
# qdel "jobid" to delete a job                            #  
###########################################################

# The name of the job, can be whatever makes sense to you

#$ST_LINE -N glide_$IN

# Force csh if not Sun Grid Engine default shell

#$ST_LINE -S /bin/sh

# The job should be placed into the queue '-q serial' or '-q mpi'. Use serial for gpu jobs!

#$ST_LINE -q serial

# Redirect output stream to this file.

#$ST_LINE -o $outDIR/logs/$IN.log

# Redirect error stream to this file.

#$ST_LINE -e $outDIR/logs/$IN.err

# The batchsystem should use the current directory as working directory.

#-cwd

# Change to the directory where the job will be executed (local disk).
export SCRATCHDIR=`mktemp -d /scratch/sruiz/tmp_XXXXXX`
cd $SCRATCHDIR
echo "Created tmp folder " $SCRATCHDIR " in server " `uname -n`


module load schrodinger
# These are the comands to be executed.

file=$IN
cp $DIR/$file .


glide -WAIT -NOJOBID -NJOBS $NJOBS $file

cp * $outDIR/

$NEXT

# Remove scratchdir
rm -rf $SCRATCHDIR
