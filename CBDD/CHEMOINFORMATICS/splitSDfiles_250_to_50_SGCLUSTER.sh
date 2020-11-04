vndr=$1
original_dir=$2
#split all sd files in groups of 50
for f in $original_dir/$vndr\_???????.sd; do newname=$vndr/$vndr\_`basename ${f%%.sd}`; sdsplit -50 $f -o${newname}_split; done

#rename all sd files sequentially
i=1; for f in $vndr/*split*sd; do mv $f $vndr/$vndr\_KK_$i.sd; let i=$i+1; done

#correctly number the files

for f in $vndr/$vndr\_KK_[0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_00000000/); done
for f in $vndr/$vndr\_KK_[0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_0000000/); done
for f in $vndr/$vndr\_KK_[0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_000000/); done
for f in $vndr/$vndr\_KK_[0-9][0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_00000/); done
for f in $vndr/$vndr\_KK_[0-9][0-9][0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_0000/); done
for f in $vndr/$vndr\_KK_[0-9][0-9][0-9][0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_000/); done
for f in $vndr/$vndr\_KK_[0-9][0-9][0-9][0-9][0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_00/); done
for f in $vndr/$vndr\_KK_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_0/); done

#remove original files
#echo rm $vndr\_???????.sd
