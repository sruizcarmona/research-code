#!/bin/bash

f=$1
jarn=$2

cd $f/DUCK_$jarn

	gnuplot -e "set terminal dumb; 	plot 'duck.dat' using 1:4"

cd ../..
