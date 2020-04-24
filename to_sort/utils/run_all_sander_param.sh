#!/bin/sh

#######################
# to run execute: sh run_all_sander_param.sh <dihedral atom 1> <dihedral atom 2> <dihedral atom 3> <dihedral atom 4> <root name of all files>
#######################

#degrees, from 0 to 360 5 by 5
number=`seq 0 5 360`
rank=5000 #used in dihedral restraint (force)

#define root name for all files
rootname=$5
#define dihedral atoms
dihedral_atom1=$1
dihedral_atom2=$2
dihedral_atom3=$3
dihedral_atom4=$4 

#first, run tleap!
#template for tleap file, will write $rootname.tleap
tleapfile="params = loadAmberParams $rootname.frcmod\n
MOL = loadMol2 $rootname.mol2\n
check MOL\n
charge MOL\n
saveAmberParm MOL $rootname.top $rootname.crd\n
saveOff params $rootname.off\n
saveOff MOL $rootname.off\n
quit\n";
echo -e $tleapfile > $rootname.tleap;

#run tleap as defined above
tleap -f $rootname.tleap;

#template for dihedral restraints file, save it in $dih_file
dih_file="&rst iat= DIH_1, DIH_2, DIH_3, DIH_4,\n
r1=AN_PREV00000, r2=ANG.000000, r3=ANG.000000, r4=ANG.100000, rk2=RANK.0, rk3=RANK.0, /\n"
echo -e $dih_file > dihedral_TEMPLATE.f;

#for each angle, use dihedral_TEMPLATE.f to create the restraint files for sander
if [ -e dih_tmp ]; then rm dih_tmp/*; else mkdir dih_tmp; fi
for N in $number;
do
	angprev_num=`echo $N-1 | bc`
	if [ $N == 0 ]; then 
		ang_prev=-0.1 
	else 
		ang_prev=$angprev_num.9
	fi
 	sed -e 's/DIH_1/'$dihedral_atom1'/g' dihedral_TEMPLATE.f | sed -e 's/DIH_2/'$dihedral_atom2'/g' | sed -e 's/DIH_3/'$dihedral_atom3'/g' | sed -e 's/DIH_4/'$dihedral_atom4'/g' | sed -e 's/AN_PREV/'$ang_prev'/g' | sed -e 's/ANG/'$N'/g' | sed -e 's/RANK/'$rank'/g' > dih_tmp/dihedral_$N.f
done

#run minimisations
#template file for min.in (will be changed for each minimisation step)
min_file="Minimization of IPR with dihedral constraints\n
&cntrl\n
imin=1,\n
ntb=0,\n
cut=15,\n
maxcyc=1000,\n
ntpr=1,\n
nmropt=1\n
/\n
&wt type='END'\n
/\n
DISANG=dih_tmp/dihedral_XXANGLEXX.f\n"
echo -e $min_file > min.in;

#for each angle, create input.in with correct dihedral restraint file, and run sander to minimize the structure
if [ -e out_$rootname ]; then rm out_$rootname/*; else mkdir out_$rootname; fi
for N in $number;
do
 sed -e 's/XXANGLEXX/'$N'/g' min.in > input.in
 if [ $N -lt 10 ]; then N=00$N; fi
 if [ $N -lt 100 -a $N -gt 9 ]; then N=0$N; fi
 $AMBERHOME/exe/sander -O -i input.in -o out_$rootname/${rootname}_$N.out -p ${rootname}.top -c ${rootname}.crd -r out_$rootname/${rootname}_$N.crd
done


#remove sander_energies if exists
if [ -e sander_energies.txt ]; then rm sander_energies.txt; fi
#get FINAL RESULTS line and retrieve last step energies
for file in out_$rootname/*.out;
do
	echo -n $file >> sander_energies.txt;
	sed -n $(echo `grep -n " FINAL " $file | awk '{print $1}' | sed 's/://'`+5 | bc )p $file >> sander_energies.txt
done
#save energies in a proper format (1 column with the energies sorted by angle)
awk '{printf "%.7f\n",$3}' sander_energies.txt > sander_energies.tab

##########CLEAN FILES#######
rm input.in
rm mdinfo
rm sander_energies.txt
rm dihedral_TEMPLATE.f
############################

#########OPTIONAL################
#create a sd file for visualization of all sander process in min_pdbs
if [ -e min_pdbs ]; then rm min_pdbs/*; else mkdir min_pdbs; fi
for N in $number;
do
	if [ $N -lt 10 ]; then N=00$N; fi
	if [ $N -lt 100 -a $N -gt 9 ]; then N=0$N; fi
	ambpdb -p ${rootname}.top < out_$rootname/${rootname}_$N.crd > min_pdbs/min_pdb_${rootname}_$N.pdb 2> /dev/null
	babel -ipdb min_pdbs/min_pdb_${rootname}_$N.pdb -osd min_pdbs/min_pdb_${rootname}_$N.sd 2> /dev/null
	cat min_pdbs/min_pdb_${rootname}_$N.sd >> min_pdbs/min_pdb_all.sd
done
#################################

#open energies file for copying to excel file
kwrite sander_energies.tab
