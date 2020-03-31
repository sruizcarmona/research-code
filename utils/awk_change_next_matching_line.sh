#look for line containing Name, and change next line "^" (beginning) for "pdb_"
sed -r "/Name/{n;s/^/pdb_/p;d}" kk > kk2
