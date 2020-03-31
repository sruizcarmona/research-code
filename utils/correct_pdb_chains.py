#!/usr/bin/python
import Biskit,sys,os

def get_PDB(file):
	pdb=Biskit.PDBModel(file)
	pdb=pdb.compress(pdb.maskProtein())
	return pdb
	
def print_chains(pdbobj):
	pdbobj.report()

def correct_files(pdbID,savepath,chainID):
	chains=[0,int(chainID)]
	complex_pdb=pdb.takeChains(chains)
	monom0_pdb=pdb.takeChains([chains[0]])
	monom1_pdb=pdb.takeChains([chains[1]])
	complex_pdb.writePdb(savepath+pdbID+"_complex.pdb")
	monom0_pdb.writePdb(savepath+pdbID+"_chain0.pdb")
	monom1_pdb.writePdb(savepath+pdbID+"_chain1.pdb")

if __name__ == "__main__":
	pdbcode=sys.argv[1]
	pdbfile=sys.argv[2]
	save_path="/mds2/sergi/AGGREGATION/interactome3d_divided_NEW/"+pdbcode+"/"
	files_path="/mds2/sergi/AGGREGATION/interactome3d/pdbs/"
	print pdbcode
	if len(sys.argv) == 3:
		pdb=get_PDB(files_path+pdbfile)
		print_chains(pdb)
	if len(sys.argv) == 4: 
		chainOK=sys.argv[3]
		pdb=get_PDB(files_path+pdbfile)
		correct_files(pdbcode,save_path,chainOK)
