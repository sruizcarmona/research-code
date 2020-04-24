import pybel,random,sys,os

system=sys.argv[1]

out=pybel.readfile('sdf',system+'_out_sorted.sd')
ligs =[]

for a in out:
  ligs.append(a)

#file with written rmsd calculations
os.system('/home/sergi/work/scripts/utils/pybel_rmsd.py ../ligand.mol '+system+'_out_sorted.sd > '+system+'_out_rmsd.txt')

rmsf=open(system+'_out_rmsd.txt','r')
rms=rmsf.readlines()
rmsf.close()

d=[]
for i,lig in enumerate(ligs):
  rmsd=rms[i].rstrip().split()[-1]
  d.append([i+1,lig.data['SCORE.INTER'],rmsd])
  
r=[]
for n in range(0,100):
  subR=[]
  for k in range(0,50):
    subR.append(random.randrange(0,999))
  r.append(subR)
  
  
sel=[]
for subr in r:
  subsel=[]
  for ind in subr:
    subsel.append(d[ind])
    subsel.sort()
  sel.append(subsel)
 
res=[]
for a in sel:
  res.append(float(a[0][2]))
  
out=open(system+'_hist_data.txt','w')
for a in res:
  out.write(str(a))
  out.write('\n')
  
out.close()

import rpy2
from rpy2 import robjects

R=rpy2.robjects
R.r.assign('R_res',res)
R.r('R_cols=c(258,515,362,404,555)')
if max(res) > 10:
	R.r('R_breaks=c(0,2,4,6,8,max(as.numeric(R_res)))')
else:
	R.r('R_breaks=c(0,2,4,6,8,10)')
R.r('pdf("'+system+'_rmsd_hist.pdf")')
R.r('hist(as.numeric(R_res),breaks=R_breaks,col=colors()[R_cols],main="",xlab="RMSD (A)",freq=TRUE)')
R.r['dev.off']()

