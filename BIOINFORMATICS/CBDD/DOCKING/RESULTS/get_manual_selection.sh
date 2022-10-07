for id in `echo a b c d e`;
do
    echo $id;
    #echo $id\_top*sd;
    for mol_id in `cat $id\_sel.txt`;
    do
        echo $mol_id;
        sdfilter -f'$_REC eq '$mol_id'' $id\_top*sd >> $id\_sel_mols.sd;
        #sdfilter -f'$_REC eq '$mol_id'' $id\_top*sd | sdreport - | grep Name | awk '{print $3}' | sed 's/\"//g';
    done
done
