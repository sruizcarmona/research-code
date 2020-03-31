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
argtf_min=sys.argv[4]
bf_cutoff=sys.argv[5] #0 for no correction

#open input files
pdbfile=Biskit.PDBModel(pdb_in)
mol2mols=pybel.readfile("mol2",mol2_in)
mol2mol=mol2mols.next()

#get atoms from mol2 and pdb
mol2atoms=[]
for atom in mol2mol:
 mol2atoms.append(atom)
pdbatoms=pdbfile.atoms

#initialize ln to 0
ln=0
#### Correction for temperature factor, in a desired range
tf_max=1
tf_min=float(argtf_min)
tf=pdbatoms['temperature_factor']

## apply cutoff for scale bfactors
try:
#bf_cutoff is the argument itself
	bf_cutoff=float(bf_cutoff)
except ValueError:
#else can be the mean + sigma, 2 mean, or mean+2sigma
	if bf_cutoff == "m" or bf_cutoff == "ms" or bf_cutoff == "m2s":
		if bf_cutoff == "m":
			bf_cutoff = tf.mean()
		elif bf_cutoff == "ms":
			bf_cutoff = tf.mean()+tf.std()
		elif bf_cutoff == "m2s":
			bf_cutoff = tf.mean()+2*tf.std()
#correcting for mean or sigma bf_cutoff values
		print "correcting for", bf_cutoff
#  		print "b",tf[338]
		for tf_i, tf_n in enumerate(tf):
			if tf_n > bf_cutoff:
				tf[tf_i] = bf_cutoff
		bf_cutoff=0 #remove cutoff value for not re-defining it after this try function
		ln=0 #flag for controlling if a ln correction has been done
	elif bf_cutoff == "ln":
		print "correcting for", bf_cutoff
		for tf_i, tf_n in enumerate(tf):
			tf[tf_i] = 1/(1+0.4*math.log(tf_n))
		bf_cutoff=0 #remove cutoff value for not re-defining it after this try function
		#tf=tf+(1-tf.max())
		ln=1
	else:
 		print "bad definition of bf_cutoff"
		raise SystemExit

#for bf_cutoff of numerical proportional runs
if bf_cutoff != 0: 
 print "correcting for", bf_cutoff
 for tf_i, tf_n in enumerate(tf):
  if tf_n > bf_cutoff:
   tf[tf_i] = bf_cutoff
##
#print tf[338]
if ln==0:
	tf=-tf #invert scale
	tf=tf-max(tf) #get maximum value to be 0
	tf=tf/-min(tf) #get minimum value to be 1
	tf=tf*(1-tf_min) #range between tf_min and 0
	tf=tf+1 #convert values again to positive values
##scale log values (different transformation than normal cutoffs)
#print tf[338]
if ln==1:
	print "correcting for LN"
	tf=tf-min(tf) #get minimum value to be 0
	tf=tf/max(tf) #get maximum value to be 1
	tf=tf-1 #invert scale
	tf=tf*(1-tf_min) #range between tf_min and 0
	tf=tf+1 #convert values again to positive values
pdbatoms['temperature_factor']=tf #assign to pdb recalculated tf values
avg_tf=sum(tf)/len(tf) #for atoms without b-factor
#print "AVG",avg_tf
###

#init bfactors dict
bfactors={}
#variable for printing %
fl=0
for i in range(0,len(pdbatoms['temperature_factor'])):
#	print "for1",pdbatoms['residue_name'][i],pdbatoms['residue_number'][i],pdbatoms['name'][i],pdbatoms['temperature_factor'][i]
	if pdbatoms[i]['element'] == 'H':
		continue
	found=0
	if int(float(i)/len(pdbatoms['temperature_factor'])*100)%5 == 0 and fl== 0:
		print float(i)/len(pdbatoms['temperature_factor'])*100,"%"
		fl=1
	elif int(float(i)/len(pdbatoms['temperature_factor'])*100)%5 == 0 and fl != 0:
		pass
	else:
		fl=0
	
#	print pdbfile.xyz[i]
	comp_tol=1e-5
	for mol2atom in mol2atoms:
		#print "mol"
		#print "mol2atom",pdbatoms['residue_name'][i],pdbatoms['name'][i],pdbatoms['temperature_factor'][i]
		#for new bfactor transformation, only applied to heavy atoms, Hs will have the same bfactor
		if mol2atom.OBAtom.IsHydrogen():
			#print "jump"
			#found=1
			continue
		#print "afterH",pdbatoms['residue_name'][i],pdbatoms['name'][i],pdbatoms['temperature_factor'][i]
		#check if atom in pdb has same coordinates than in mol2
		if abs(pdbfile.xyz[i][0] - mol2atom.OBAtom.x()) < comp_tol and abs(pdbfile.xyz[i][1] - mol2atom.OBAtom.y()) < comp_tol and abs(pdbfile.xyz[i][2] - mol2atom.OBAtom.z()) < comp_tol:
			#if so, flag it as found and assign bfactors of that mol2 atom index as the bf of the pdb
#			print "found",pdbatoms['residue_name'][i],pdbatoms['residue_number'][i],pdbatoms['name'][i],pdbatoms['temperature_factor'][i]
			found=1
			#if i == 338:
			#	print pdbatoms[i]['temperature_factor']
			bfactors[mol2atom.idx]=pdbatoms[i]['temperature_factor']
			#if i == 338:
			#	print bfactors[mol2atom.idx]
			#as the pdbs from XRAY do not have Hs, check again all atoms in mol2 file and assign the H atoms with the bfactor of the Heavy Atom to which they are connected
			for mol2atom_new in mol2atoms:
				if mol2atom.OBAtom.IsConnected(mol2atom_new.OBAtom):
					if mol2atom_new.OBAtom.IsHydrogen():
						bfactors[mol2atom_new.idx]=pdbatoms[i]['temperature_factor']
#	print found
	if found ==0:
#		print "NOT FOUND"
#		print pdbfile.xyz[i]
#		print "nf",pdbatoms['residue_name'][i],pdbatoms['name'][i],pdbatoms['temperature_factor'][i]
		for mol2atom in mol2atoms:
			if not mol2atom.OBAtom.IsHydrogen():
				dist=math.sqrt((pdbfile.xyz[i][0]-mol2atom.OBAtom.x())**2+(pdbfile.xyz[i][1]-mol2atom.OBAtom.y())**2+(pdbfile.xyz[i][2]-mol2atom.OBAtom.z())**2)
				if dist < 1:
					#print dist
					bfactors[mol2atom.idx]=pdbatoms[i]['temperature_factor']
		                        for mol2atom_new in mol2atoms:
		                                if mol2atom.OBAtom.IsConnected(mol2atom_new.OBAtom):
		                                        if mol2atom_new.OBAtom.IsHydrogen():
		                                                bfactors[mol2atom_new.idx]=pdbatoms[i]['temperature_factor']
					break
#	print bfactors

#print bfactors

mol2file=open(mol2_in).read().split("\n")[:-1]
newmol2=[]
for line in mol2file:
	split_line=line.split()
	if len(split_line) > 8:
 		if int(split_line[0]) in bfactors.keys():
			#line=line[:77]+" %.4f"%bfactors[int(split_line[0])]
			#line=line[:line.index(line.split()[8])+len(line.split()[8])]+" %.4f"%bfactors[int(split_line[0])]
			line=line[:[i.end() for i in re.finditer(line.split()[8],line)][-1]]+" %.4f"%bfactors[int(split_line[0])]
		else:
			#line=line[:77]+" %.4f"%avg_tf
			#line=line[:line.index(line.split()[8])+len(line.split()[8])]+" %.4f"%avg_tf
			line=line[:[i.end() for i in re.finditer(line.split()[8],line)][-1]]+" %.4f"%avg_tf
	newmol2.append(line)
out=open(mol2_out,"w")
out.write("\n".join(newmol2))
out.close()
