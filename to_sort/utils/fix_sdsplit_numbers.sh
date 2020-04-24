#!/bin/sh

dudsys=$1

for f in $dudsys\_split[0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_split/$dudsys\_split000/); done
for f in $dudsys\_split[0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_split/$dudsys\_split00/); done
for f in $dudsys\_split[0-9][0-9][0-9].sd; do $(echo -n mv $f ''; echo $f | sed s/$dudsys\_split/$dudsys\_split0/); done
