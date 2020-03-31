#!/usr/bin/python
#this script will assign a title from a given field
#usage: python blabla.py MOL_FILE FIELD OUTFILE

import pybel,sys

#files declaration
mol_file=sys.argv[1] #sdf file
field=sys.argv[2] #list file
out_file=sys.argv[3] #output name

molecules=pybel.readfile("sdf",mol_file)
out_file=pybel.Outputfile("sdf",out_file)

for molecule in molecules:
	molecule.title=molecule.data[field]
	out_file.write(molecule)

out_file.close()
