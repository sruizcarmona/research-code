vndr=$1
#split all sd files in groups of 50
for f in $vndr\_???????.sd; do sdsplit -50 $f -o${f%%.sd}_split; done

#rename all sd files sequentially
i=1; for f in *split*sd; do mv $f $vndr\_KK_$i.sd; let i=$i+1; done

#correctly number the files

for f in $vndr\_KK_[0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_00000000/); done
for f in $vndr\_KK_[0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_0000000/); done
for f in $vndr\_KK_[0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_000000/); done
for f in $vndr\_KK_[0-9][0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_00000/); done
for f in $vndr\_KK_[0-9][0-9][0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_0000/); done
for f in $vndr\_KK_[0-9][0-9][0-9][0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_000/); done
for f in $vndr\_KK_[0-9][0-9][0-9][0-9][0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_00/); done
for f in $vndr\_KK_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$vndr\_KK_/$vndr\_0/); done

#remove original files
echo rm $vndr\_???????.sd
