#!/bin/sh
###########################################################
# USAGE:                                                  #
# qsub queue_whatever.csh to submit a job                 #
# qstat to monitorize your jobs                           #
# qstat -f to see an overview of the queues               #
# qdel "jobid" to delete a job                            #  
###########################################################

# The name of the job, can be whatever makes sense to you

#$ST_LINE -N rdock_$FILE

# Force csh if not Sun Grid Engine default shell

#$ST_LINE -S /bin/sh

# The job should be placed into the queue '-q serial' or '-q mpi'. Use serial for gpu jobs!

#$ST_LINE -q serial

# Redirect output stream to this file.

#$ST_LINE -o $DIR/results/logs/ostream_$OUT.log

# Redirect error stream to this file.

#$ST_LINE -e $DIR/results/logs/estream_$OUT.log

# The batchsystem should use the current directory as working directory.

#-cwd

# Change to the directory where the job will be executed (local disk).
export SCRATCHDIR=`mktemp -d /scratch/sruiz/tmp_XXXXXX`
cd $SCRATCHDIR
echo "Created tmp folder " $SCRATCHDIR " in server " `uname -n`

#export JOBDIR=$DIR/
export RBT_ROOT=/xpeople/sruiz/soft/rdock/2006.src
export LD_LIBRARY_PATH=$RBT_ROOT/lib
export RBT_HOME=$DIR
# These are the comands to be executed.

cp $DIR/$PWY_R .
$RBT_ROOT/bin/rbdock -i $FILE -o $OUT -r $IN -p $SCMAT -n $NRUNS

gzip $OUT.log
mv $OUT.log.gz $DIR/results/logs
mv $OUT.sd $DIR/results

# Remove scratchdir
rm -rf $SCRATCHDIR
