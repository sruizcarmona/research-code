[COMMAND]
command="export SCHRODINGER=/soft/schrodinger_2010; export SCHRODINGER_NODEFILE=/soft/schrodinger_2010/nodefile; $SCHRODINGER/glide -WAIT -NOJOBID -NJOBS $NJOBS glide_in"


[INPUT]
glide_in=$IN


[NEXT]
command="$NEXT_LIGJOB"
