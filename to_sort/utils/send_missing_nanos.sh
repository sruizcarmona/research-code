miss=$1
echo $miss
for f in LIG_*;
do
        echo $f;
        if [ $miss == "equil" ]
        then
                if [ ! -e $f/4_eq.nc ];
                then
                        cd $f;
                        mnsubmit $miss.q;
                        cd ..;
                fi
        elif [ ! -e $f/$miss.nc ];
        then
                cd $f;
                mnsubmit $miss.q;
                cd ..;
        fi
done;
