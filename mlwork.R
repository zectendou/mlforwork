library(tidyverse)
library(tidymodels)


set.seed(100) #as you like it

data_split <- initial_split(data, p = 0.8)
df_train = training(data_split)
df_test = testing(data_split)

cooking = recipe(y~ ., data = df_train) %>%
  step_center(y)%>%
  step_ordinalscore(all_nominal()) #とくちょーりょーえんじにゃーりんぐ


#あぷらいとぅーでーた
cook_preped = cooking %>%
  prep(df_train)

df_train_baked = cooke_preped %>%
  juice()

df_test_beked = rec_preped %>% 
  bake(df_test)


#モデルの選定 今回はランダムフォレスト(ロジスティック回帰・L1or2正則化などでも可能)
rf = rand_forest(mode = "regression", 
                 trees = 50,
                 min_n = 10,
                 mtry = 3) %>% 
  set_engine("ranger", num.threads = parallel::detectCores(), seed = 100)

fitted = rf %>% 
  fit(y ~ ., data = df_train_baked)


#予測
df_result = df_test_baked %>% 
  select(y) %>% 
  bind_cols(predict(fitted, df_test_baked))

#評価

df_result %>% 
  metrics(y, .pred)