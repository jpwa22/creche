library(sf)
library(dplyr)
library(mapview)
library(tmap)




pasta <- "C:\\Users\\joaopaulo.andrade\\Documents\\NCD\\GIS_BASES_GEOESPACIAIS\\PE\\Shape-RM-Recife\\"

#shapefile <- read_sf(str_c(pasta,"RM_Recife_dissolve.shp"))


pasta <- "C:\\Users\\joaopaulo.andrade\\Documents\\NCD\\GIS_BASES_GEOESPACIAIS\\BASES_SEPLAG\\EDUCAÇÃO\\"
arquivo <- "PE_CRECHES_PUBLICAS_ESTADUAIS_MUNICIPAIS_MICRODADOCENSOESCOLAR2022_SIRGAS2000.shp"
shapefile <- stringr::str_c(pasta,arquivo)
creches <- st_read(shapefile)
creches <- creches %>% filter(NO_MUNICIP == "Recife")

plot(creches$geometry)
g = st_make_grid(creches)
plot(st_geometry(g),add = TRUE)
plot(g[creches], col = '#ff000088', add = TRUE)






mapview_creches <- mapview(creches, cex = 3, alpha = .5, popup = NULL)

area_fishnet_grid = st_make_grid(creches, what = "polygons", square = TRUE)
str(area_fishnet_grid)


# To sf and add grid ID
fishnet_grid_sf = st_sf(area_fishnet_grid) %>%
  # add grid ID
  mutate(grid_id = 1:length(lengths(area_fishnet_grid)))
# count number of points in each grid
# https://gis.stackexchange.com/questions/323698/counting-points-in-polygons-with-sf-package-of-r
fishnet_grid_sf$n_creche = lengths(st_intersects(fishnet_grid_sf, creches))

# remove grid without value of 0 (i.e. no points in side that grid)
fishnet_count = filter(fishnet_grid_sf, n_creche > 0)






tmap_mode("view")

map_fishnet = tm_shape(fishnet_count) +
  tm_fill(
    col = "n_creche",
    palette = "Reds",
    style = "cont",
    title = "Numero de Creches",
    id = "grid_id",
    showNA = FALSE,
    alpha = 0.5,
    popup.vars = c(
      "Número de Creches: " = "n_creche"
    ),
    popup.format = list(
      n_creche = list(format = "f", digits = 0)
    )
  ) +
  tm_borders(col = "grey40", lwd = 0.7)

map_fishnet
