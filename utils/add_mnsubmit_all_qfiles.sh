for f in `seq 1 50`
do
        next=`echo $f + 1 | bc`
        sed 's/exit/mnsubmit md'$next'.q\nexit/' md$f.q > tmp;
        mv tmp md$f.q;
done
