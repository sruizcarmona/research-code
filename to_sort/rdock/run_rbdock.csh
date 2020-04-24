rbcavity -r tmp.prm -was ## to write the dpcking site 
rbcavity -r tmp.prm -d ## to generate the cavity grid

rbdock -i test_lig.sdf -o test.out -r tmp.prm -p dock.prm -n 10 
