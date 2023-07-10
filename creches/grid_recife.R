
library(sf)
library(dplyr)
library(mapview)
library(tmap)

creches <- st_read("shapes/PE_CRECHES_PUBLICAS_ESTADUAIS_MUNICIPAIS_MICRODADOCENSOESCOLAR2022_SIRGAS2000.shp")
creches <- creches %>% filter(NO_MUNICIP == "Recife")

plot(creches$geometry)
g = st_make_grid(creches)
plot(st_geometry(g),add = TRUE)
plot(g[creches], col = '#ff000088', add = TRUE)


# Shape com o setor censitário de Pernambuco
setor <- st_read("shapes/setor_censitario/PE_Setores_2021.shp")
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
# Filtrando apenas RMR
setor_rmr <- subset(setor, NM_MUN %in% rmr)
# Visualizando os setores
plot(setor_rmr$geometry)




