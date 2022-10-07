for f in pains*smi;
do
    echo $f
    cat $f | while read line;
    do
        smarts=`echo $line | awk '{print $1}'`;
        name=`echo $line | awk '{print $2}'`;
        echo $name;
        obabel all_uniq.sd -s$smarts -osmi -O kk.smi;
    done
done
