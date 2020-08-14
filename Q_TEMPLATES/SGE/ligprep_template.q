[COMMAND]
command="export SCHRODINGER=/soft/schrodinger_2010; export SCHRODINGER_NODEFILE=/soft/schrodinger_2010/nodefile; $SCHRODINGER/ligprep -nt -ns -isd $LIG_IN -omae $LIG_OUT -WAIT"


[NEXT]
command="$NEXT_LIGJOB"
