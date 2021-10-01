############
### PATH ###
############

# getwd()
setwd("/Users/alexvlima/Library/Mobile Documents/com~apple~CloudDocs/Vacinacao-Covid/")

#################
### LIBRARIES ###
#################

library(tidyverse)
library(vroom)
library(lubridate)
library(gganimate)
library(hrbrthemes)

###############
### DATASET ###
###############

df <- vroom(file = "Dados/part-00000-8003b473-aecc-4ea9-be6d-282dd178874a-c000.csv", 
            delim = ";",
            col_select = c(
                           "vacina_descricao_dose",
                          "vacina_dataaplicacao",
                          "paciente_endereco_coibgemunicipio"))
glimpse(df)

df <- 
  df %>%
  filter(vacina_dataaplicacao >= as.Date("2020-12-01")) %>%
  group_by(Dose = vacina_descricao_dose, Data = vacina_dataaplicacao) %>%
  summarise(Qtde = n()) %>%
  mutate(Qtde = Qtde / 1000) 

fonte <- stringr::str_glue(
  "Fonte: Datasus\n",
  "Elaboração: DIRAT"
)

df2 <- 
  df %>%
  group_by(Semana = cut(Data, "week")) %>%
  summarise(Qtde = sum(Qtde, na.rm = T)) %>%
  mutate(Qtde = ifelse(Semana == as.character("2021-07-12"),Qtde*7,Qtde)) 

p <- 
  df %>%
  group_by(Semana = cut(Data, "week")) %>%
  summarise(Qtde = sum(Qtde, na.rm = T)) %>%
  mutate(Qtde = ifelse(Semana == as.character("2021-07-12"),Qtde*7,Qtde)) %>%
  ggplot(aes(x = as.Date(as.character(Semana)), y = Qtde)) +
  geom_line(size = 1.2, color = "steelblue") + 
  geom_point() +   
  labs(
    x = "Semana", 
    y = "Qtde (em mil)",
    fill = "",
    alpha = "",
    title = "Quantidade de Doses Aplicadas por Semana",
    caption = fonte
  ) +
  theme_ipsum() +
  theme(plot.title = element_text(hjust = 0.5)) + 
  transition_reveal(as.Date(as.character(Semana)))

animate(p, renderer=gifski_renderer("serie_vacinacao.gif"))
  
