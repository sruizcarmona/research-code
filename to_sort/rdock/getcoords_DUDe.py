import sys,os

file=sys.argv[1]
#file="../rbdock/alr2_rbdock_cav1.grd"
f=open(file,"r")
lines=f.readlines()
f.close()

dists=[float(el) for el in (lines[2].rstrip().split()[:3])]
coords=[float(el) for el in (lines[4].rstrip().split()[1:])]

center=[(dists[0]+coords[0])/2]
center.append((dists[1]+coords[2])/2)
center.append((dists[2]+coords[4])/2)


os.system("python $SCRIPTS/createGridIn.py -g $(perl -e '@F=split(/\//,$ENV{PWD});print \"$F[5]\n\"')_grid.zip -r /xpeople/sruiz/DUDe/$(perl -e '@F=split(/\//,$ENV{PWD});print \"$F[5]\n\"')/glide/$(perl -e '@F=split(/\//,$ENV{PWD});print \"$F[5]\n\"')_rec_grid.maegz -f $(perl -e '@F=split(/\//,$ENV{PWD});print \"$F[5]\n\"')_grid.in -c \""+str('%.5f' % center[0])+" "+str('%.5f' % center[1])+" "+str('%.5f' % center[2])+"\" -x "+str('%.5f' % dists[0])+" -y "+str('%.5f' % dists[1])+" -z "+str('%.5f' % dists[2]))

#os.system("python $SCRIPTS/createQin_glide.py -t $SCRIPTS/files/glide_template.q -c 1 -i $(perl -e '@F=split(/\//,$ENV{PWD});print \"$F[5]\n\"')_grid.in -n $(perl -e '@F=split(/\//,$ENV{PWD});print \"$F[5]\n\"')_grid.q")


