#!/usr/bin/python
import pybel,sys,Biskit,math,re

####
# assign pdb b-factors as to a new column in mol2 file, previously converted to a desired range
# from 0.2 to 1 applying a desired cutoff in the bfactors
# python get_bfactor_to_mol2.py FILE.pdb FILE.mol2 FILE-OUT.mol2
####
pdb_in=sys.argv[1]
mol2_in=sys.argv[2]
mol2_out=sys.argv[3]
tf_or_occ=sys.argv[4]
tf_max=float(sys.argv[5])
#argtf_min=sys.argv[4]
#NO CUTOFF
#bf_cutoff=sys.argv[5] #0 for no correction 

#open input files
pdbfile=Biskit.PDBModel(pdb_in)
mol2mols=pybel.readfile("mol2",mol2_in)
mol2mol=mol2mols.next()

#get atoms from mol2 and pdb
mol2atoms=[]
for atom in mol2mol:
 mol2atoms.append(atom)
pdbatoms=pdbfile.atoms

#### Correction for temperature factor, in a desired range
#tf_max=float(5)
#tf_min=float(argtf_min)
tf_min=1
#tf_or_occ='temperature_factor'
#tf_or_occ='occupancy'
if tf_or_occ == "both":
	tftfx = pdbatoms["temperature_factor"]
	tfocy = pdbatoms["occupancy"]
else:
	tf=pdbatoms[tf_or_occ]

#print tf[338]
#################################################
# Function to give weights according to ASA (2-10)
#################################################
if tf_or_occ == 'temperature_factor':
	print "Correcting for ",tf_or_occ
	for i,tfi in enumerate(tf):
		if tfi == 0:
			tf[i]=tf_min
		elif tfi < 2: #to create the slope from 2 to 10 ASA
			tf[i]=tf_max
		elif tfi < 10:
			tf[i]=(1-tf_max)/8*tfi+(10*tf_max-2)/8
		else:
			tf[i]=tf_min
	pdbatoms[tf_or_occ]=tf #assign to pdb recalculated tf values
	avg_tf=sum(tf)/len(tf) #for atoms without b-factor
#print "AVG",avg_tf
#################################################
# Function to give weights according to SLOPE (-5 to -50)
#################################################
# SLOPE SLOPE SLOPE
####
if tf_or_occ == 'occupancy':
	print "Correcting for ",tf_or_occ
	for i,tfi in enumerate(tf):
		if tfi > -5:
			tf[i]=tf_min
		elif tfi > -50:
			tf[i]=(1-tf_max)/45*tfi+(50-5*tf_max)/45
		else:
			tf[i]=tf_max
	pdbatoms[tf_or_occ]=tf #assign to pdb recalculated tf values
	avg_tf=sum(tf)/len(tf) #for atoms without b-factor
#print "AVG",avg_tf
#################################################
# Function to give weights according to BOTH PARAMETER
#################################################
# BOTH BOTH BOTH BOTH
####
if tf_or_occ == 'both':
	print "Correcting for ",tf_or_occ
	#correct tftfx ASA for having a range between 2 and 10:
#	print tftfx[0:30]
	for i,tfi in enumerate(tftfx):
		if tfi == 0:
			tftfx[i]=10
		elif tfi > 10:
			tftfx[i]=10
		elif tfi < 2:
			tftfx[i]=2
#	print tftfx[0:30]
#	print tfocy[0:30]
	#correct tfocy SLOPE for having a range between -50 and -5:
	for i,tfi in enumerate(tfocy):
		if tfi > -5:
			tfocy[i]=-5
		if tfi < -50:
			tfocy[i]=-50
#	print tfocy[0:30]
	tf=[]
	for i in range(0,len(tftfx)):
		newtf=((-tftfx[i])/8.+10./8.)*((-tfocy[i])/45.-1./9.)*(tf_max-1)+1
		tf.append(newtf)
		#print tftfx[i],tfocy[i],newtf
	tf_or_occ="temperature_factor"
#	print "tf",tf[0:30]
	pdbatoms[tf_or_occ]=tf #assign to pdb recalculated tf values
	avg_tf=sum(tf)/len(tf) #for atoms without b-factor
#print "AVG",avg_tf
#################################################

#init bfactors dict
bfactors={}
#variable for printing %
fl=0
for i in range(0,len(pdbatoms[tf_or_occ])):
#	print "for1",pdbatoms['residue_name'][i],pdbatoms['residue_number'][i],pdbatoms['name'][i],pdbatoms[tf_or_occ][i]
	if pdbatoms[i]['element'] == 'H':
		continue
	found=0
	if int(float(i)/len(pdbatoms[tf_or_occ])*100)%5 == 0 and fl== 0:
		print float(i)/len(pdbatoms[tf_or_occ])*100,"%"
		fl=1
	elif int(float(i)/len(pdbatoms[tf_or_occ])*100)%5 == 0 and fl != 0:
		pass
	else:
		fl=0
	
#	print pdbfile.xyz[i]
	comp_tol=1e-5
	for mol2atom in mol2atoms:
		#print "mol"
		#print "mol2atom",pdbatoms['residue_name'][i],pdbatoms['name'][i],pdbatoms[tf_or_occ][i]
		#for new bfactor transformation, only applied to heavy atoms, Hs will have the same bfactor
		if mol2atom.OBAtom.IsHydrogen():
			#print "jump"
			#found=1
			continue
		#print "afterH",pdbatoms['residue_name'][i],pdbatoms['name'][i],pdbatoms[tf_or_occ][i]
		#check if atom in pdb has same coordinates than in mol2
		if abs(pdbfile.xyz[i][0] - mol2atom.OBAtom.x()) < comp_tol and abs(pdbfile.xyz[i][1] - mol2atom.OBAtom.y()) < comp_tol and abs(pdbfile.xyz[i][2] - mol2atom.OBAtom.z()) < comp_tol:
			#if so, flag it as found and assign bfactors of that mol2 atom index as the bf of the pdb
#			print "found",pdbatoms['residue_name'][i],pdbatoms['residue_number'][i],pdbatoms['name'][i],pdbatoms[tf_or_occ][i]
			found=1
			#if i == 338:
			#	print pdbatoms[i][tf_or_occ]
			bfactors[mol2atom.idx]=pdbatoms[i][tf_or_occ]
			#if i == 338:
			#	print bfactors[mol2atom.idx]
			#as the pdbs from XRAY do not have Hs, check again all atoms in mol2 file and assign the H atoms with the bfactor of the Heavy Atom to which they are connected
			for mol2atom_new in mol2atoms:
				if mol2atom.OBAtom.IsConnected(mol2atom_new.OBAtom):
					if mol2atom_new.OBAtom.IsHydrogen():
						bfactors[mol2atom_new.idx]=pdbatoms[i][tf_or_occ]
#	print found
	if found ==0:
#		print "NOT FOUND"
#		print pdbfile.xyz[i]
#		print "nf",pdbatoms['residue_name'][i],pdbatoms['name'][i],pdbatoms[tf_or_occ][i]
		for mol2atom in mol2atoms:
			if not mol2atom.OBAtom.IsHydrogen():
				dist=math.sqrt((pdbfile.xyz[i][0]-mol2atom.OBAtom.x())**2+(pdbfile.xyz[i][1]-mol2atom.OBAtom.y())**2+(pdbfile.xyz[i][2]-mol2atom.OBAtom.z())**2)
				if dist < 1:
					#print dist
					bfactors[mol2atom.idx]=pdbatoms[i][tf_or_occ]
		                        for mol2atom_new in mol2atoms:
		                                if mol2atom.OBAtom.IsConnected(mol2atom_new.OBAtom):
		                                        if mol2atom_new.OBAtom.IsHydrogen():
		                                                bfactors[mol2atom_new.idx]=pdbatoms[i][tf_or_occ]
					break
#	print bfactors

#print bfactors

mol2file=open(mol2_in).read().split("\n")[:-1]
newmol2=[]
for line in mol2file:
	split_line=line.split()
	if len(split_line) > 8:
 		if int(split_line[0]) in bfactors.keys():
                        line=line[:[i.end() for i in re.finditer(line.split()[8],line)][-1]]+" %.4f"%bfactors[int(split_line[0])]
                else:
                        line=line[:[i.end() for i in re.finditer(line.split()[8],line)][-1]]+" %.4f"%avg_tf
	newmol2.append(line)
out=open(mol2_out,"w")
out.write("\n".join(newmol2))
out.write("\n")
out.close()
