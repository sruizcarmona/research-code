#!/usr/bin/sh

dudsys=$1

cd glide/results/;
zcat *.maegz > $dudsys\_all_results.mae;
gzip $dudsys\_all_results.mae;
mv $dudsys\_all_results.mae.gz $dudsys\_all_results.maegz;
cd ../..;

cd rdock/results;
cat *t.sd > $dudsys\_all_results.sd;
gzip *t.sd;
cd ../../;
