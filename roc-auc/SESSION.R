# http://biostat.mc.vanderbilt.edu/wiki/Main/DataSets

library(ggplot2)
library(party)
library(pROC)

df_tree <- dec_tree()
plot_pred_type_distribution(df_tree, 0.7)
roc_tree <- calculate_roc(df_tree, 1, 3)

df_reg <- log_reg()
roc_reg <- calculate_roc(df_reg, 1, 3)

plot_roc(roc_reg)

pROC::auc(df$survived, df$pred)

#plot(roc$threshold, roc$cost)

