dec_tree <- function() {
  df <- read_and_prepare_titanic_dataset("~/Downloads/titanic3.csv")
  
  tree <- ctree(survived ~ ., data=df, 
                controls = ctree_control(
                  teststat="quad",
                  testtype="Univariate",
                  mincriterion=.95,
                  minsplit=10, 
                  minbucket=5,
                  maxdepth=0
                ))
  
  df$pred <- predict(tree, newdata=df, type="prob")
  df$pred <- unlist(lapply(df$pred, function(el)el[2]))
  
  return(df)
}