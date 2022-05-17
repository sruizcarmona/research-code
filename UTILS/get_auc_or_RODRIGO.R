get_auc <- function(glm_out, df, col_pred) {
    pred <- predict(glm_out, df)
    ro <- roc(col_pred, pred)
    au <- as.numeric(auc(ro))
    ci <- as.numeric(ci(ro))
    print(paste(format(au,digits=4)," [",
                format(ci[1],digits=4),", ",
                format(ci[3],digits=4), "]", sep=""))
    return(c(au, ci[1], ci[3]))   
}

get_ors <- function(glm_out) {
    lreg.or <- exp(cbind(OR = coef(glm_out), confint(glm_out)))
    lreg.or <- round(lreg.or, digits=4)
    OR_data <- as.data.table(lreg.or)
    OR_data$V <- rownames(lreg.or)
    colnames(OR_data) <- c("OR", "O_Low", "O_High", "Pred")
    return(OR_data)
}
