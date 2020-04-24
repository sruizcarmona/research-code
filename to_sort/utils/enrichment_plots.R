enrichment_plot <- function(compare){
y <- NULL
for (a in seq(1:length(res))){
y <- c(y,sum(compare %in% res[1:a]))
}
plot(seq(1:length(res))/length(res),y/y[length(y)],type="l")
abline(0,1)
}
