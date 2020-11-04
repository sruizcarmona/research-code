#!/usr/bin/python
#first we will have to read all files from astex folders containing histogram data
# run from ASTEX folder ~/work/ASTEX

import glob,os, sys

l=[]
for fold in glob.glob('*/'):
  if not fold == '1of6/':
    l.append(fold+'rdock/results_1000/'+fold[:-1]+'_hist_data.txt')
  
enr=[]
for file in l:
  a=open(file,'r')
  lines=[]
  for line in a:
    lines.append(line.rstrip())
  a.close()
  lnum=map(float,lines)
  s=0
  for n in lnum:
    if n < 2:
     s=s+1
  enr.append(s/float(len(lnum)))
  
 
import rpy2
from rpy2 import robjects 

R=rpy2.robjects
R.r.assign('R_res',enr)
R.r('pdf("ASTEX_ALL.pdf")')
R.r('hist(as.numeric(R_res))')
R.r('dev.off()')
