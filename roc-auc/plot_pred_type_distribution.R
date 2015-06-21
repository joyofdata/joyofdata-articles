plot_pred_type_distribution <- function(df, threshold) {
  v <- rep(NA, nrow(df))
  v <- ifelse(df$pred >= threshold & df$survived == 1, "TP", v)
  v <- ifelse(df$pred >= threshold & df$survived == 0, "FP", v)
  v <- ifelse(df$pred < threshold & df$survived == 1, "FN", v)
  v <- ifelse(df$pred < threshold & df$survived == 0, "TN", v)
  
  df$pred_type <- v
  
  ggplot(data=df, aes(x=survived, y=pred)) + 
    geom_violin(fill=rgb(1,1,1,alpha=0.6), color=NA) + 
    geom_jitter(aes(color=pred_type)) + 
    geom_hline(aes(yintercept=threshold), color="red")
  
}