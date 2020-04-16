##area under the curve of any curve
get_integral_area <- function(xcoords, ycoords){
	if (length(xcoords) != length(ycoords)) {
		print ("Lengths of both coords must be equal")
		return (0);
	}
	sum_integral=0;
	for (i in c(1:length(xcoords))){
		if (i < length(xcoords)){
			up=(ycoords[i]+ycoords[i+1])/2;
			down= xcoords[i+1]-xcoords[i];
			sum_integral=sum_integral+(up*down);
		}
	}
	return (sum_integral);
}

#input x and y coordinates of normal ROC curve, and it will generate corrected log10 figures to calculate logAUC
get_logAUC <- function(xauc,yauc){
	xauc=log10(xauc)
	xauc_min=range(xauc[xauc != -Inf])[1]
	xauc=(xauc-xauc_min)/-xauc_min
	xauc[xauc == -Inf] = 0
	int_area=get_integral_area(xauc,yauc)
	return (int_area)
}




