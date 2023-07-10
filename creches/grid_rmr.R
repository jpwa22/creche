
library(sf)
library(dplyr)
library(mapview)
library(tmap)
library(ggplot2)
# lista de municípios da RMR
rmr <- c(
  'Araçoiaba',
  'Igarassu',
  'Itapissuma',
  'Ilha de Itamaracá',
  'Abreu e Lima',
  'Paulista',
  'Olinda',
  'Camaragibe',
  'Recife',
  'Jaboatão dos Guararapes',
  'São Lourenço da Mata',
  'Moreno',
  'Cabo de Santo Agostinho',
  'Ipojuca'
)



creches <- st_read("shapes/PE_CRECHES_PUBLICAS_ESTADUAIS_MUNICIPAIS_MICRODADOCENSOESCOLAR2022_SIRGAS2000.shp")
creches <- creches %>% filter(NO_MUNICIP == "Recife")
creches <- subset(creches, NO_MUNICIP %in% rmr)


plot(creches$geometry)
g = st_make_grid(creches)
plot(st_geometry(g),add = TRUE)
plot(g[creches], col = '#ff000088', add = TRUE)




# Setores Censitários -----------------------------------------------------

pe <-readRDS("arquivos/pe.rds")

pe[,1:21] <- lapply(pe[,1:21],as.character)
str(pe[,1:21])
dim(pe[,22:ncol(pe)])

# Shape com o setor censitário de Pernambuco
setor <- st_read("shapes/setor_censitario/PE_Setores_2021.shp")

# Filtrando apenas RMR
setor_rmr <- subset(setor, NM_MUN %in% rmr)
setor_rmr$geometry2 <- setor_rmr$geometry

# Visualizando os setores
plot(setor_rmr$geometry)
# mapview(
#   list(setor_rmr,creches),
#   layer.name = c("Setor Censitário", "Creches")
# )

creches_setor <- st_join(creches,setor_rmr)
View(creches_setor[1,])
colnames(creches_setor)


tm_
tm_shape(creches_setor$geometry) + tm_fill() + tm_borders() 

