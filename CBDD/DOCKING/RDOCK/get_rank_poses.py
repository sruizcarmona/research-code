#!/usr/bin/python
import sys

lfile=open("../../../ligands/ligands.txt").read().split()
lset=set(lfile)

res_sorted_file=sys.argv[1]
rfile=[item.split() for item in open(res_sorted_file).read().split("\n")][:-1]

col=int(sys.argv[2])

for i in lset:
	for j,k in enumerate(rfile):
		if i == k[col]:
			print i
			print j
			
