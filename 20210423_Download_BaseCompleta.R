############
### PATH ###
############

# getwd()
setwd("/Users/alexvlima/Downloads/Vacinacao-Covid/")

################
### DOWNLOAD ###
################

link <- "https://s3-sa-east-1.amazonaws.com/ckan.saude.gov.br/PNI/vacina/completo/2021-04-22/part-00000-c366ecbc-537b-4983-8d04-aca8937c9c1d-c000.csv"

download.file(link, "Dados/BaseCompleta.csv")

rm(link)
    
