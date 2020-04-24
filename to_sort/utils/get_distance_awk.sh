system=$1
dist_file=$1/dist_md.rst
pdb_file=$1/lib/system_solv.pdb

#get atoms selected
selAs=$(grep iat= $dist_file | awk '{print $2}'  | awk '{print $2}' FS="=" | awk '{print $1,$2}' FS=",")
selA1=${selAs% *}
selA2=${selAs#* } 
#echo $selA1
#echo $selA2
echo -n $system ""


awk '$2=='$selA1'{x1=$6;y1=$7;z1=$8;at1=$3}                                 # get the ATOM 1
      $2=='$selA2'{x2=$6;y2=$7;z2=$8;at2=$3}                               # get the ATOM 2
      END{print '$selA1,$selA2',at1,at2,sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) + (z1-z2)*(z1-z2))}' $pdb_file
