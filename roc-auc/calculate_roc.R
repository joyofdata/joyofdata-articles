#' Calculate ROC
#' 
#' @param df The data.frame containing the predictions and true values.
#' @param pred_column The column name of df containing the predictions.
#' @param target_column The column name of df containing the target.
#' @param cost_of_fp The cost of false positives.
#' @param cost_of_fn The cost of false negatives.
#' @param n The number of points to compute on the ROC curve.
#' 
#' @return A data.frame containing the ROC curve at n points.
#' 

calculate_roc <- function(df, pred_column="pred", target_column="survived",
                          cost_of_fp=1, cost_of_fn=1, n=100) {
  tpr <- function(df, threshold) {
    sum(df[[pred_column]] >= threshold & df[[target_column]] == 1) /
          sum(df[[target_column]] == 1)
  }
  
  fpr <- function(df, threshold) {
    sum(df[[pred_column]] >= threshold & df[[target_column]] == 0) / sum(df[[target_column]] == 0)
  }
  
  cost <- function(df, threshold, cost_of_fp, cost_of_fn) {
    sum(df[[pred_column]] >= threshold & df[[target_column]] == 0) * cost_of_fp + 
      sum(df[[pred_column]] < threshold & df[[target_column]] == 1) * cost_of_fn
  }
  
  roc <- data.frame(threshold = seq(0,1,length.out=n), tpr=NA, fpr=NA)
  roc$tpr <- sapply(roc$threshold, function(th) tpr(df, th))
  roc$fpr <- sapply(roc$threshold, function(th) fpr(df, th))
  roc$cost <- sapply(roc$threshold, function(th) cost(df, th, cost_of_fp, cost_of_fn))
  
  return(roc)
}
