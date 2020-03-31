#!/bin/tcsh
set number=`seq 0 5 360`
set rank=500
set dihedral_atom1=3
set dihedral_atom2=4
set dihedral_atom3=7
set dihedral_atom4=8
foreach N ($number)
	set angprev_num=`echo $N-1 | bc`
	if ( $N == 0 ) then 
		set ang_prev=-0.1 
	else 
		set ang_prev=$angprev_num.9
	endif
 	sed -e 's/DIH_1/'$dihedral_atom1'/g' dihedral_TEMPLATE.f | sed -e 's/DIH_2/'$dihedral_atom2'/g' | sed -e 's/DIH_3/'$dihedral_atom3'/g' | sed -e 's/DIH_4/'$dihedral_atom4'/g' | sed -e 's/AN_PREV/'$ang_prev'/g' | sed -e 's/ANG/'$N'/g' | sed -e 's/RANK/'$rank'/g' > dihedral_$N.f
end
