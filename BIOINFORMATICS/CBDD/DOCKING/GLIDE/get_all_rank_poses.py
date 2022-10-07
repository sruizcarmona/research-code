#!/usr/bin/python
import sys

lfile=open("/home/sergi/list_glide_guided_hsp90.txt").read().split()
lset=set(lfile)
lset=lfile

res_sorted_file=sys.argv[1]
rfile=[item.split() for item in open(res_sorted_file).read().split("\n")][:-1]

col=int(sys.argv[2])

for i in lset:
	for j,k in enumerate(rfile):
		if i == k[col]:
			print k[3]
			#print j+1
			
