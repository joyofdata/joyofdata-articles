log_reg <- function() {
  df <- read_and_prepare_titanic_dataset("~/Downloads/titanic3.csv")
  
  lr <- glm(survived ~ ., data = df, family = binomial(logit))
  df$pred <- predict(lr, newdata=df, type="response")
  return(df)  
}