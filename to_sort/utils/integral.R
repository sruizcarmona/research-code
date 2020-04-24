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
