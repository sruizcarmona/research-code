#!/usr/bin/Rscript
args <- commandArgs(trailingOnly=TRUE);
#print (args)
i=1;
for (arg in args){
	distances_data <- read.table(arg)
	if (i == 1){
		#pdf("distances_plot.pdf")
		jpeg("distances_plot.jpg")
		x_plot <- distances_data[,1]/500
		y_plot <- distances_data[,2]
		plot(x_plot,y_plot,type="lines", col=palette()[i],ylim=c(1,30),xlab="Time(ns)",ylab=bquote(paste("Distance" ~ (ring(A)))))
		plotted=arg
		cols=c(palette()[i])
	} else {
		y_plot <- distances_data[,2]
		lines(x_plot,y_plot, col=palette()[i])
		plotted=c(plotted,arg)
		cols=c(cols,palette()[i])
	}
	i=i+1;
}
legend("topright",plotted, cex=0.6, col=cols,lty=1,lwd=2)

dev.off()

print ("The plots have been saved in file distances_plot.pdf")
