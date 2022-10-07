a <- read.csv("kk.csv")

calc_oldlogS <- function (logp, mw, rotor, ringatoms, heavyatoms){
	c_oldlogS <- 0.16 - 0.63 * logp - 0.0062 * mw + 0.066 * rotor - 0.74 * (ringatoms/heavyatoms)
	return (c_oldlogS)
}

calc_newlogS <- function (logp, mw, rotor, ringatoms, heavyatoms) {
	c_newlogS = 0.233743817233-0.74253027*logp-0.00676305*mw+0.01580559*rotor-0.35483585*(ringatoms/heavyatoms);
	return (c_newlogS)
}

oldlogs=NULL
newlogs=NULL

for ( i in seq(1:dim(a)[1])){
	oldlogs=c(oldlogs, calc_oldlogS(a$QPlogPo.w[i], a$mol_MW[i], a$X.rotor[i], a$X.ringatoms[i], a$X.nonHatm[i]))
	newlogs=c(newlogs, calc_newlogS(a$QPlogPo.w[i], a$mol_MW[i], a$X.rotor[i], a$X.ringatoms[i], a$X.nonHatm[i]))
}

reflogs=a$QPlogS

print (oldlogs)
print(newlogs)
print(reflogs)
