miss=$1
echo $miss
for f in LIG_L_*;
do
        echo $f;
        if [ ! -e $f/JAR_$miss/jar_$miss.x.gz ];
        then
                cd $f/JAR_$miss;
                mnsubmit jar_$miss.q;
                cd ../..;
        fi
        if [ ! -e $f/JAR_325K_$miss/jar_$miss.x.gz ];
        then
                cd $f/JAR_325K_$miss;
                mnsubmit jar_325K_$miss.q;
                cd ../..;
        fi
done;

