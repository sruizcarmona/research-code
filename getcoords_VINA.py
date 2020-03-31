import sys,os,string

#file to read 1, template 2 and file towrite 3
file=sys.argv[1]
template=sys.argv[2]
outfile=sys.argv[3]
dudsys=sys.argv[4]

#read grid file
f=open(file,"r")
lines=f.readlines()
f.close()

#calculate distances and coordinates
dists=[float(el) for el in (lines[2].rstrip().split()[:3])]
coords=[float(el) for el in (lines[4].rstrip().split()[1:])]
#get center
center=[(dists[0]+coords[0])/2]
center.append((dists[1]+coords[2])/2)
center.append((dists[2]+coords[4])/2)

#exhaustiveness and max num modes:
exhaust=16
nummodes=100

#read template
tmp = open(template, 'r')
tmp_str = tmp.read()
tmp.close()

d = {'RECEPTOR':dudsys+'_receptor.pdbqt','CENT_X':center[0],'CENT_Y':center[1],'CENT_Z':center[2],'DIST_X':dists[0],'DIST_Y':dists[1],'DIST_Z':dists[2],'EXH':exhaust,'NUM':nummodes}
q_out = string.Template(tmp_str).substitute(d)

#write the output
q = open(outfile, 'w')
q.write(q_out)
q.close()



