############
### PATH ###
############

# getwd()
setwd("/Users/alexvlima/Library/Mobile Documents/com~apple~CloudDocs/Vacinacao-Covid/")

###############
### DATASET ###
###############

vacinacao_datasus <- read_csv2("Dados/Base_Agrupada.csv")
pop_ibge_2021 <- read_csv2("Dados/pop_ibge_2021.csv")

################
### ANALYSIS ###
################

fonte <- stringr::str_glue(
  "Fonte:\n",
  "População: IBGE\n",
  "Vacinação: Datasus\n",
  "Elaboração: DIRAT"
)

datasus <- 
  vacinacao_datasus %>% 
  filter(IDADE >= 18, IDADE < 90, SEXO %in% c("M","F")) %>%
  mutate(SEXO = ifelse(SEXO == "M", "Homens", "Mulheres"),
         TIPO = stringr::str_squish(DOSE)) %>%
  mutate(TIPO = ifelse(TIPO %in% c("1ª Dose","Dose Inicial", "Dose"), "1ª Dose", 
                       ifelse(TIPO %in% c("2ª Dose", "3ª Dose", "Única"), "2ª Dose",NA))) %>%
  filter(TIPO %in% c("1ª Dose", "2ª Dose")) %>%
  select(-DOSE) %>%
  group_by(SEXO, IDADE, TIPO) %>%
  summarise(N = sum(N))

pop_ibge_2021$IDADE <- as.numeric(gsub("(^\\d{2}).*", "\\1", pop_ibge_2021$IDADE))  
pop_ibge_2021$TIPO <- "População"

pop <- 
  pop_ibge_2021 %>% 
  filter(IDADE < 90) %>%
  group_by(SEXO, IDADE, TIPO) %>%
  summarise(N = sum(POP))

dados <- dplyr::bind_rows(pop, datasus)

dados %>% 
  dplyr::mutate(N = N * ((SEXO == "Homens") * 2 -1)) %>% 
  dplyr::mutate(TIPO = forcats::lvls_reorder(TIPO, c(2, 1, 3))) %>% 
  ggplot(aes(x = N, y = factor(IDADE), fill = SEXO, alpha = TIPO)) +
  geom_col(width = 1, position = "identity") +
  annotate(geom = "text", x = 0, y = seq(3, 73, 10), label = seq(20, 90, 10)) +
  scale_x_continuous(
    breaks = seq(-1500, 1500, 500) * 1000,
    labels = paste0(abs(seq(-1500, 1500, 500)), "K")
  ) +
  scale_y_discrete(breaks = seq(0, 100, 10)) + 
  scale_fill_viridis_d(begin = .3, end = .8, option = "C") +
  scale_alpha_manual(values = c(1, .6, .3)) +
  theme_minimal() +
  labs(
    x = "População", 
    y = "Idade",
    fill = "",
    alpha = "",
    title = "Vacinação no Brasil em 14 de julho de 2021",
    caption = fonte
  ) +
  # guides(fill = guide_legend(reverse = TRUE)) +
  theme(
    panel.grid.minor = element_blank(),
    axis.text.y = element_blank(),
    legend.position = "none",
    plot.title = element_text(hjust = .5)
  )

