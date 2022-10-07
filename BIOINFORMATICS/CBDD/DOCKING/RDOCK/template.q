[COMMAND]
command="rbdock -i $PWY -o $OUT -r $IN -p dock.prm -n $NRUNS"

#[NEXT]
#command="queue -a $NEXT"

[INPUT]
$IN=$IN
$AS=$AS
$MOL2=$MOL2

[OUTPUT]
output=$OUT.sd



