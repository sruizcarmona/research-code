#!/usr/bin/python


import pybel,sys

file=sys.argv[1]
field=sys.argv[2]
out=sys.argv[3]

mols=pybel.readfile('sdf',file)

fout=open(out,'w')


for mol in mols:
	mol.title=mol.data[field]
	str=mol.write('smi')
	fout.write(str)

fout.close()
