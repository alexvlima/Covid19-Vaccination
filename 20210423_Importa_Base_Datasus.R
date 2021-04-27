############
### PATH ###
############

# getwd()
setwd("/Users/alexvlima/Downloads/Vacinacao-Covid/")

#################
### LIBRARIES ###
#################

library(tidyverse)
library(vroom)

###############
### DATASET ###
###############

df <- vroom(file = "Dados/BaseCompleta.csv", 
            delim = ";", 
            col_select = c("paciente_idade",
                          "paciente_enumSexoBiologico",
                          "paciente_endereco_coIbgeMunicipio",
                          "vacina_descricao_dose"))
glimpse(df)

df$UF <- 
  as.numeric(substr(df$paciente_endereco_coIbgeMunicipio, 1, 2))
df$paciente_endereco_coIbgeMunicipio <- NULL

colnames(df) <- c("IDADE","SEXO","DOSE","UF")

df <- 
  df %>%
  group_by(IDADE, SEXO, DOSE, UF) %>%
  summarise(N = n())

write_csv2(x = df, path = "Dados/Base_Agrupada.csv")

rm(df)
