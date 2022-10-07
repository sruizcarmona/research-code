#! /usr/bin/env bash
# run on output files from rdock, check that there are no other aromatic bonds and convert all double bonds to singleones
sed -e "s/ 2  0  0  0/ 1  0  0  0/g" $1 > `basename $1 .sd`_forsdrmsd.sdf

