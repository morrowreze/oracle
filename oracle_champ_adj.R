library(dplyr)

load('~/oracle/data/oracle_clean.Rdata')

champ_dat = dat %>%
  filter(player != team) %>%
  group_by(champion) %>%
  summarise_if(is.numeric, mean, na.rm = TRUE)

cadj_comb = dat %>%
  left_join(champ_dat, by = 'champion', suffix = c('_p', '_c'))

cadj_share = cadj_comb %>%
  select(ends_with('_p'), ends_with('_c'))

cadj_dat = cadj_comb %>%
  select(-ends_with('_p'), -ends_with('_c'))

cadj_sub = cadj_share[,1:78] - cadj_share[,79:156]
names(cadj_sub) = sapply(names(cadj_sub), FUN = function(x) substr(x,1,nchar(x) - 2))

cadj = cadj_dat %>%
  bind_cols(cadj_sub)

rm(list = setdiff(ls(), 'cadj'))

save(cadj, file = '~/oracle/data/oracle_cadj.Rdata')
