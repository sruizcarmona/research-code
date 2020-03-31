#!/bin/sh
input=$1
output=$2
molconvert "png:w1200,-H,+a,chiral_all"  -2 $input -o kk.png -m
for f in kk[1-9].png; do $(echo -n mv $f ''; echo $f | sed s/kk/kk0/); done
montage -geometry 1200 kk*png $output
rm kk*png
#xdg-open $output
