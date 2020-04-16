#!/bin/bash
###########################################################
# USAGE:                                                  #
# qsub queue_whatever.sh to submit a job                  #
# qstat to monitorize your jobs                           #
# qstat -f to see an overview of the queues               #
# qdel "jobid" to delete a job                            #  
###########################################################

# The name of the job, can be whatever makes sense to you

#$ST_LINE -N glide_MPI

# Force csh if not Sun Grid Engine default shell

#$ST_LINE -S /bin/bash

# The job should be placed into the queue '-q serial' or '-q mpi'. Use serial for gpu jobs!

#$ST_LINE -q mpi

# Redirect output stream to this file.

#$ST_LINE -o $DIR/ostream.log

# Redirect error stream to this file.

#$ST_LINE -e $DIR/estream.log

# The batchsystem should use the current directory as working directory.
##############

# PARALLEL ENVIRONMENT (MANDATORY)
# Change num_procs to the desired number of cpus to use (max 16, recommended 8)

#$ST_LINE -pe mpich2_mpd $NJOBS

# CPU Reservation (MANDATORY)
# To ensure your job will have enough free cpus at some point.

#$ST_LINE  -R y

# MANDATORY LINES FOR THE PARALLEL ENVIRONMENT FOR BASH SHELL
# CHANGE << export >> TO << set >> FOR CSH OR TCSH

export MPICH2_ROOT=/opt/mpich2
export PATH=$MPICH2_ROOT/bin:$PATH
export MPD_CON_EXT="sge_$JOB_ID.$SGE_TASK_ID"
############

#-cwd

# Change to the directory where the job will be executed (local disk).
export SCRATCHDIR=`mktemp -d /scratch/sruiz/tmp_XXXXXX`
cd $SCRATCHDIR
echo "Created tmp folder " $SCRATCHDIR " in server " `uname -n`

# These are the comands to be executed.

module load schrodinger
# These are the comands to be executed.

file=$IN
cp $DIR/$file .

glide -WAIT -NOJOBID -NJOBS $NJOBS $file

cp * $DIR/

# Remove scratchdir
rm -rf $SCRATCHDIR
