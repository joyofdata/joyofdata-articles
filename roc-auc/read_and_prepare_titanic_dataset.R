read_and_prepare_titanic_dataset <- function(f) {
  df <- read.table(f, header = TRUE, sep=",", stringsAsFactors = FALSE)
  
  df$pclass <- as.factor(df$pclass)
  df$survived <- as.factor(df$survived)
  df$sex <- as.factor(df$sex)
  
  df <- df[,c("survived","pclass","sex","age","sibsp","parch")]
  df <- df[complete.cases(df),]
  
  return(df)
}