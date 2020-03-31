#!/usr/bin/python

#####################################################################
# this script gets a sdf file <*.sdf> and makes necessary changes 
# for screening assistant input:
# - removes "M CHG  0" lines
# - removes all fields with ligprep info
# - adds a field "id" with the vendor code
#####################################################################


import pybel,sys

infile=sys.argv[1]
outfile=sys.argv[2]


## remove "M CHG  0" error lines
nochg_file=infile.replace(".sdf","_noCHG0.sdf")
out_nochg=open(nochg_file,"w")
for line in open(infile):
	if "CHG  0" not in line:
		out_nochg.write(line)
out_nochg.close()

## add the first line ID into a field "vendor_id"
#open input file (without CHG 0 lines) and output sdf file for final output file
input_sdf=pybel.readfile("sdf",nochg_file)
output_sdf=pybel.Outputfile("sdf",outfile)

#loop for each molecule
#remove all ligprep info fields and add field id with vendor_id
for mol in input_sdf:
	mol.data.clear()
	mol.data["id"]=mol.title
	output_sdf.write(mol)

output_sdf.close()

