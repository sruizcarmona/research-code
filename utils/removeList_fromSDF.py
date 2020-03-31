#!/usr/bin/python
#this script will remove the molecules contained in a list (with the IDs) from a given sdf file.
#usage: python blabla.py MOL_FILE CODES_FILE OUT_LIST

import pybel,sys

#files declaration
mol_file=sys.argv[1] #sdf file
codes_file=sys.argv[2] #list file
out_file=sys.argv[3] #output name

molecules=pybel.readfile("sdf",mol_file)
codes_list=open(codes_file).read().split("\n")
out_file=pybel.Outputfile("sdf",out_file)

for molecule in molecules:
	if molecule.title not in codes_list:
		out_file.write(molecule)

out_file.close()
