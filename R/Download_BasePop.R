############
### PATH ###
############

# getwd()
setwd("/Users/alexvlima/Downloads/Vacinacao-Covid/")

#################
### LIBRARIES ###
#################

library(sidrar)

###############
### DATASET ###
###############

x <- c(seq(from = 6575, to = 6642, by = 1), seq(from = 6656, to = 6659, by = 1), 49110)
idade <- paste(x, collapse = ",")

api <- paste0("/t/7358/n3/all/c2/all/c287/",idade,"/c1933/49037")

pop_ibge_2021 <- get_sidra(api = api)
glimpse(pop_ibge_2021)

rm(x, idade, api)

#################
### WRANGLING ###
#################

pop_ibge_2021 <- 
  pop_ibge_2021 %>%
  select(UF = `Unidade da Federação (Código)`, NOME_UF = `Unidade da Federação`,
         SEXO = Sexo, IDADE = Idade, POP = Valor) %>%
  filter(SEXO != "Total", IDADE != "Total")

write_csv2(x = pop_ibge_2021, path = "Dados/pop_ibge_2021.csv")

rm(pop_ibge_2021)
