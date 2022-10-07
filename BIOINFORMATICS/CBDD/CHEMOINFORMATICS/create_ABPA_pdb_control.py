import Biskit,sys

pdb_in=sys.argv[1]
pdb_out_nos=sys.argv[2]
pdb_out_all=sys.argv[3]

m=Biskit.PDBModel(pdb_in)
a=m.atoms

for i in range(len(m.xyz)):
   if a[i]['element'] in ['N','O']:
    a[i]['temperature_factor'] = 2

m.writePdb(pdb_out_nos)

for i in range(len(m.xyz)):
   a[i]['temperature_factor'] = 2
   
m.writePdb(pdb_out_all)
