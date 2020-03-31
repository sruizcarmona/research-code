#!/bin/bash
###########################################################
# USAGE:                                                  #
# qsub queue_whatever.sh to submit a job                  #
# qstat to monitorize your jobs                           #
# qstat -f to see an overview of the queues               #
# qdel "jobid" to delete a job                            #  
###########################################################

# The name of the job, can be whatever makes sense to you

$INT_QSUB -N $NAME

# Force csh if not Sun Grid Engine default shell

$INT_QSUB -S /bin/bash

#######################################
###Mail when job starts and finishes
##
##$INT_QSUB -M sruizcarmona@gmail.com
##$INT_QSUB -m bes
#######################################

# The job should be placed into the queue '-q serial' or '-q mpi'. Use serial for gpu jobs!

$INT_QSUB -q $QUEUE

# Redirect output stream to this file.

$INT_QSUB -o $DIR/results/streams/$NAME.dat

# Redirect error stream to this file.

$INT_QSUB -e $DIR/results/streams/$NAME.err

# The batchsystem should use the current directory as working directory.
##############

# PARALLEL ENVIRONMENT (MANDATORY)
# Change num_procs to the desired number of cpus to use (max 16, recommended 8)

$INT_QSUB -pe mpich2_mpd $NCPUS

# CPU Reservation (MANDATORY)
# To ensure your job will have enough free cpus at some point.

$INT_QSUB  -R y

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


cp $DIR/$CONF_FILE .
cp $DIR/ligs_pdbqt/$LIG_FILE .
cp $DIR/$RECEPTOR_FILE .

/xpeople/sruiz/VINA/bin/vina --config $CONF_FILE --ligand $LIG_FILE --out $OUT_FILE --log $LOG_FILE --cpu $NCPUS

mv $OUT_FILE $DIR/results
mv $LOG_FILE $DIR/results/logs

source /xpeople/sruiz/qsub.bashrc
$NEXT_JOB

# Remove scratchdir
rm -rf $SCRATCHDIR
