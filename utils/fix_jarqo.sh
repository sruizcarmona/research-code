sys=$1
jarN=$2

#1.- for 300K
cd JAR_$jarN
################
##FIX JAR.q.o
################
origin=../../../LIGS_JAR_SETB/LIG_target_$sys/
origin_str=`grep submission  $origin/JAR_$jarN/jar_$jarN.q.o`
origin_tocopy=${origin_str:25:14}
b=`grep submission jar_$jarN.q.o`
b_tocopy=${b:25:14}
sed "s@$b_tocopy@$origin_tocopy@" jar_$jarN.q.o > kk;
mv kk jar_$jarN.q.o;
##############
##FIX JAR.o
##############
grep " 11/" jar_$jarN.o
sed 's/ 11\// 02\//' jar_$jarN.o > kk;
mv kk jar_$jarN.o;
cd ..;
#2.- for 325K
cd JAR_325K_$jarN
################
##FIX JAR.q.o
################
origin=../../../LIGS_JAR_SETB/LIG_target_$sys/
origin_str=`grep submission  $origin/JAR_325K_$jarN/jar_$jarN.q.o`
origin_tocopy=${origin_str:25:14}
b=`grep submission jar_$jarN.q.o`
b_tocopy=${b:25:14}
sed "s@$b_tocopy@$origin_tocopy@" jar_$jarN.q.o > kk;
mv kk jar_$jarN.q.o;
##############
##FIX JAR.o
##############
grep " 11/" jar_$jarN.o
sed 's/ 11\// 02\//' jar_$jarN.o > kk;
mv kk jar_$jarN.o;
cd ..;
