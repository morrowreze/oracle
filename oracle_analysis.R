library(dplyr)
library(ggplot2)
library(devtools)
library(ggjoy)

cbpalette = c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
load('./data/oracle_clean.Rdata')
load('./data/oracle_cadj.Rdata')

s = cadj %>%
  filter(split %in% c('2017-1', '2017-1po', '2017-2'),
         player %in% c('Bjergsen', 'Jensen', 'Pobelter', 'Huhi', 'Froggen'),
         position == 'Middle',
         league == 'NALCS')

# gold difference at 15
title = 'Early Gold Difference'
val = 'Gold Difference at 15'
p_ord = s %>%
  group_by(player) %>%
  summarise(mean = mean(gdat15)) %>%
  arrange(desc(mean))

p_gdat15 = s %>%
  mutate(player = factor(player,
                         levels = p_ord$player,
                         ordered = TRUE))

ggplot(p_gdat15, aes(player, gdat15)) +
  geom_hline(yintercept = 0, col = 'darkred', alpha = 0.50) +
  geom_violin(col = 'white') +
  geom_jitter(data = s, aes(player, gdat15, fill = player),
              width = 0.10,
              alpha = 0.25,
              pch = 21) +
  stat_summary(fun.y = mean, geom = "point", shape = 21, size = 3, col = 'black', fill = 'white') +
  scale_fill_manual(values = cbpalette) +
  scale_y_continuous(limits = c(-max(abs(s$gdat15)),
                                max(abs(s$gdat15)))) +
  labs(x = 'Player',
       y = val,
       title = title,
       fill = 'Player') +
  theme(plot.title = element_text(hjust = 0.5))

# cs share post 15
title = 'CS Allocation'
val = 'CS Share Post 15 Minutes'
ggplot(s, aes(player, cssharepost15)) +
  geom_hline(yintercept = 0, col = 'darkred', alpha = 0.50) +
  geom_violin(col = 'white') +
  geom_jitter(data = s, aes(player, cssharepost15, fill = player),
              width = 0.10,
              alpha = 0.25,
              pch = 21) +
  stat_summary(fun.y = mean, geom = "point", shape = 20, size = 3) +
  scale_fill_manual(values = cbpalette) +
  coord_cartesian(ylim = c(-0.15, 0.15)) +
  labs(x = 'Player',
       y = val,
       title = title,
       fill = 'Player') +
  theme(plot.title = element_text(hjust = 0.5))

# damage share
title = 'Share of Team\'s Damage to Champs'
val = 'Damage Share'
ggplot(s, aes(player, dmgshare)) +
  geom_hline(yintercept = 0, col = 'darkred', alpha = 0.50) +
  geom_violin(col = 'white') +
  geom_jitter(data = s, aes(player, dmgshare, fill = player),
              width = 0.10,
              alpha = 0.25,
              pch = 21) +
  scale_fill_manual(values = cbpalette) +
  labs(x = 'Player',
       y = val,
       title = title,
       fill = 'Player') +
  theme(plot.title = element_text(hjust = 0.5))

ggplot(s, aes(dmgshare, player)) +
  geom_vline(xintercept = 0, col = 'darkred', alpha = 0.50) +
  geom_joy(alpha = 0.50)
