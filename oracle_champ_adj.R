library(dplyr)

load('./data/oracle_clean.Rdata')

dat = dat %>%
  filter(player != 'Team')

champ_dat = dat %>%
  group_by(champion) %>%
  summarise_if(is.numeric, mean, na.rm = TRUE) %>%
  ungroup()

champ_dat[is.na(champ_dat)] = NA

cp_join = dat %>%
  left_join(champ_dat, by = 'champion', suffix = c('_p', '_c'))

cadj_starter = cp_join %>%
  select(-ends_with('_p'), -ends_with('_c'))

player_dat = cp_join %>%
  select(ends_with('_p'))

champ_dat = cp_join %>%
  select(ends_with('_c'))

cadj_dat = player_dat - champ_dat



cadj = cadj_dat %>%
  bind_cols(cadj_starter)

names(cadj) = gsub('_p$', '', names(cadj))

save(cadj, file = '~/oracle/data/oracle_cadj.Rdata')
