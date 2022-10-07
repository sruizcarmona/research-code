import sys
import gzip

file_name = sys.argv[1]

f=gzip.open(file_name)
all_lines =f.readlines()
f.close()

ligands = []

for i,line in enumerate(all_lines):
	if 'i_i_glide_posenum' in line:
		ligands.append(int(all_lines[i+2].strip()))

for lig in ligands:
	print lig	