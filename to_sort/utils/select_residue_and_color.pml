from pymol import cmd,stored

#LOAD PDB FILE
#ELENA: CANVIA EL NOM DEL PDB
load jocs3.pdb

#LIST OF SELECTED RESIDUES
#ELENA: CANVIA LA LLISTA DE RESIDUS
stored.list=[1,2,3,4,5,6,7]
print stored.list

#show sticks, change color of res in list
for my_index in stored.list: cmd.select("sel_res_"+str(my_index), "resi "+str(my_index))
for my_index in stored.list: cmd.color(my_index,"sel_res_"+str(my_index)+" and element c")
for my_index in stored.list: cmd.show("sticks","sel_res_"+str(my_index))
