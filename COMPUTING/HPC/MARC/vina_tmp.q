[COMMAND]
command="/marc/data/sruiz/VINA/bin/vina --config $CONF_FILE --ligand $LIG_FILE --out $OUT_FILE --log $LOG_FILE --cpu $NCPUS"

[INPUT]
$CONF_FILE=../$CONF_FILE
$LIG_FILE=../ligs_pdbqt/$LIG_FILE
$RECEPTOR_FILE=../$RECEPTOR_FILE

$NEXT_JOB
