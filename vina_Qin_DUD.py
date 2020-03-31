import re,os,sys,string,shutil

#for file in ligs_pdbqt create Qinfile (jump 2 by 2 to use 16 CPUs)

def main():
	if len(sys.argv) < 3: sys.exit("USAGE: python vina_Qin.py dudSys tmpFile")
	dudsys=sys.argv[1]
	tmp_file=sys.argv[2]
	outdir='/xpeople/sruiz/DUD/'+dudsys+'/vina'
	f=open(tmp_file,'r')
	tmp_str=f.read()
	f.close()
	ligslist=os.listdir('vina/ligs_pdbqt')
	ligslist.sort(cmp)
	
	#for running vina every sequencially, 1 and 2, then 3 and 4...
	start_q='cd q_files; for file in *lig000*.q; do qsub $file; done; qsub '+ligslist[99].replace('.pdbqt','.q')+' ;'
	start_file=open('start_vina.sh','w')
	start_file.write(start_q)
	start_file.close()
	shutil.move('start_vina.sh','vina')
	#for running vina every sequencially, 1 and 2, then 3 and 4...
	#start_q='cd q_files; for file in *.q; do qsub $file; done;'
	#start_file=open('add_all_vina.sh','w')
	#start_file.write(start_q)
	#start_file.close()

	for i,lig in enumerate(ligslist):
		lig_name=lig.split('.')[0]

		#template parameters
		if i < len(ligslist)-100:
			next='qsub '+outdir+'/q_files/'+ligslist[i+100].replace('.pdbqt','.q')
		else:
			next='#LAST FILES, NO NEXT JOB'	

		ncpus=8
		conf_file='vina_conf.txt'	
		lig_file=lig
		out_file=lig_name+'_out.pdbqt'
		log_file=lig_name+'_out.log'
		receptor=dudsys+'_receptor.pdbqt'
		#output q file
		name=lig_name+'.q'
	
	        d = {'NEXT_JOB':next,'LIG_FILE':lig_file,'OUT_FILE':out_file,'LOG_FILE':log_file,'NCPUS':ncpus,'RECEPTOR_FILE':receptor,'CONF_FILE':conf_file,'NAME':'vina_'+lig_name,'QUEUE':'mpi','INT_QSUB':'#$','SCRATCHDIR':'$SCRATCHDIR','DIR':outdir,'MPICH2_ROOT':'$MPICH2_ROOT','PATH':'$PATH','JOB_ID':'$JOB_ID','SGE_TASK_ID':'$SGE_TASK_ID'}
	        q_out = string.Template(tmp_str).substitute(d)
	        q = open(name, 'w')
	        q.write(q_out)
	        q.close()
		shutil.move(name,'vina/q_files')
		


if __name__== "__main__":
    	main()
