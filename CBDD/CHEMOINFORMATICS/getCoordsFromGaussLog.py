#!/usr/bin/python

import sys

log = sys.argv[1]
outname = sys.argv[2]

pdbstr="ATOM%7.0f%3s%6s%6.0f%12.3f%8.3f%8.3f%6.2f%7.3f%11s\n"

fin = open(log,'r')
line = fin.readline()
sp=0
molecule = {}
defined =False
elem = {'1':'H','6':'C','7':'N','8':'O','16':'S'}
orient = []
# Save atom number and element and standard orientations
while line:
	if 'Stationary point found' in line:
		# New point. Find Input orientation section
		while not 'Input orientation' in line:
			line = fin.readline()
		# Input orientation line reached
		for i in range(4): fin.readline() #skip header
		line = fin.readline()
		o = {}
		sp += 1
		while '--' not in line:
			#store atom number and element
			splited = line.split()
			if not defined: molecule[splited[0]] = elem[splited[1]]
			# store xyz
			o[splited[0]] = map(float,splited[3:])			
			line = fin.readline()
		orient.append(o)
		# Molecule defined in first input orientation section
		if not defined: defined = True
	line = fin.readline()
fin.close()

print "Found %i orientaitons (%i processed)"%(sp,len(orient))
print "Saving pdbs for all orientations..."
for i,o in enumerate(orient):
	out = open(outname+'_%04i.pdb'%(i+1),'w')	
	ati=1
	for at,coords in o.iteritems():
		out.write(pdbstr%(ati,molecule[at],'RES',1,coords[0],coords[1],coords[2],1,0,molecule[at]))	
		ati+=1
	out.close()
print "DONE"
