library(glmnet)

set.seed(100)
df_fit <- cv.glmnet(x = x,y =y,family = "binomial", standardize = T)
coef(df_fit, s = "lambda.min")