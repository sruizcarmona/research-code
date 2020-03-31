#!/usr/bin/python

import datetime,sys

#open files
#from command line!
#final_time='Tue Jan 10 17:34:56 CET 2012\n'

final_file=sys.argv[1]
start_file=sys.argv[2]

ffile=open(final_file,'r') #open finish time file
final_time=ffile.read()
ffile.close()

ssfile=open(start_file,'r') #open start time file
start_time=ssfile.read()
ssfile.close()

FMT='%H:%M:%S'

ft=final_time.rstrip().split()[3]
st=start_time.rstrip().split()[3]

fHMS=datetime.datetime.strptime(ft,FMT)
sHMS=datetime.datetime.strptime(st,FMT)


time_diff=fHMS-sHMS

tdiff_sec=time_diff.seconds
tdiff_min=tdiff_sec/60


print 'The job took '+str(tdiff_min)+' minutes approx.'

