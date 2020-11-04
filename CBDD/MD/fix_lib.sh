sys=$1
cd lib;
################
##FIX system.pdb leap.log
################
origin=../../../LIGS_JAR_SETB/$sys/
origin_str=`grep Feb $origin/lib/system.pdb`
origin_tocopy=${origin_str:55:11}
b=`grep Nov system.pdb`
b_tocopy=${b:55:11}
sed "s@$b_tocopy@$origin_tocopy@" system.pdb > kk;
mv kk system.pdb;
sed "s@$b_tocopy@$origin_tocopy@" leap.log > kk;
mv kk leap.log;
##############
##FIX system.prmtop
##############
or_day=${origin_str:64:2}
bday=${b:64:2}
grep " 11/" system_solv.prmtop
sed "s@ 11/$bday/@ 02/$or_day/@" system_solv.prmtop > kk;
mv kk system_solv.prmtop;
cd ..;
