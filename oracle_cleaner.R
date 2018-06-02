library(readxl)
library(dplyr)
library(data.table)

complete_2016 = fread('./data/2016-complete-match-data-OraclesElixir-2017-09-18.csv',
                      sep = ',',
                      colClasses = list(character = 1:92))
complete_2017 = fread('./data/2017matchdataOraclesElixir.csv',
                      sep = ',',
                      colClasses = list(character = 1:98))
spring_2018 = fread('./data/2018-spring-match-data-OraclesElixir-2018-05-20.csv',
                    sep = ',',
                    colClasses = list(character = 1:98))

dat = bind_rows(complete_2016, complete_2017, spring_2018) %>%
  mutate(patchno = factor(patchno,
                          levels = unique(patchno)[order(unique(patchno))],
                          ordered = TRUE),
         date = regmatches(date, regexpr('^[0-9]*', date)),
         date = as.Date(as.numeric(date), origin = '1899-12-30')) %>%
  mutate_at(vars(gamelength,
                 fbtime:ckpm,
                 fdtime,
                 heraldtime,
                 fttime,
                 fbarontime,
                 dmgtochamps:earnedgoldshare,
                 wpm,
                 wardshare,
                 wcpm,
                 visiblewardclearrate,
                 invisiblewardclearrate,
                 earnedgpm,
                 gspd,
                 cspm),
            funs(as.numeric(.))) %>%
  mutate_at(vars(k:pentas,
                 teamdragkills:oppelders,
                 teamtowerkills,
                 opptowerkills,
                 teambaronkills,
                 oppbaronkills,
                 wards,
                 wardkills,
                 visionwards,
                 visionwardbuys,
                 totalgold,
                 goldspent,
                 minionkills:monsterkillsenemyjungle,
                 goldat10:csdat15),
            funs(as.integer(.)))

save(dat, file = './data/oracle_clean.Rdata')
