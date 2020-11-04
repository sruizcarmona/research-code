import string,os,sys

###Q INPUT

tmp="template.prm"
name="SPECS_%d.sd"
nruns = 30
rng=1
inp='cacy.prm'
asfile='cacy.as'
mol2='cacy.mol2'
pwy='/marc/data/sruiz/rdock/ligands/'

#####RDOCK PRM FILE
astex_protein=os.path.abspath(".").split("/")[5] #name of astex protein
prm_tmp='template.prm' 
prm_title=astex_protein+'_ASTEX' 
prm_recfile=astex_protein+'_rdock.mol2'
prm_ligfile='ligand.mol'
prm_rad=6.0
prm_name=astex_protein+'_rdock.prm'

f = open(prm_tmp, 'r')
tmp_str = f.read()
f.close()

for i in range(rng):
	sd = name%(i+1)
	queue_fname = '%d.q'
	d = {'IN':inp,'PWY':pwy+sd,'SD':sd,'OUT':sd.replace('.sd','_out'),'NRUNS':nruns, 'NEXT':queue_fname%(i+2),'AS':asfile,'MOL2':mol2,'PRM_TITLE':prm_title,'PRM_RECEPTOR_FILE':prm_recfile,'PRM_LIGAND_FILE':prm_ligfile,'PRM_RADIUS':prm_rad}
	q_out = string.Template(tmp_str).substitute(d)
	q = open(prm_name, 'w')
	q.write(q_out)
	q.close()
