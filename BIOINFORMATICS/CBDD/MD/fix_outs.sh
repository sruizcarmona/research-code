sys=$1
################
##FIX *q.o
################
origin=../../LIGS_JAR_SETB/$sys/
for file in *.q.o; 
do
	origin_str=`grep submission $origin/$file`
	origin_tocopy=${origin_str:25:14}
	b=`grep submission $file`
	b_tocopy=${b:25:14}
	sed "s@$b_tocopy@$origin_tocopy@" $file > kk;
	mv kk $file;
done
##############
##FIX *out
##############
for file in *out;
do
	grep " 11/" $file
	sed 's/ 11\// 02\//' $file > kk;
	mv kk $file;
done
