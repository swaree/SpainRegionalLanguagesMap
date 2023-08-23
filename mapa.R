library(tidyverse)
library(stringr)
library(rgdal)
library(rgeos)
library(plotly)
library(dbplyr)
library(dplyr)
library(sf)
library(ggplot2)
library(maptools)

# Lectura del fichero .shp
municipios <- read_sf(
  "./datos/lineas_limite/recintos_municipales_inspire_peninbal_etrs89/recintos_municipales_inspire_peninbal_etrs89.shp"
)

municipios = municipios %>%
  mutate(
    c_autonoma = stringr::str_sub(string = NATCODE, start = 3, end = 4),
    provincia  = stringr::str_sub(string = NATCODE, start = 5, end = 6),
    municipio  = stringr::str_sub(string = NATCODE, start = 7, end = -1)
  )

ggplot(municipios) +
  geom_sf(fill = "gray80", color = "gray72", size = 0.01) +
  # geom_sf(fill = "transparent", color = "gray52", size = 0.02, 
  #         data = . %>% group_by(provincia) %>% summarise()) +
  # geom_sf(fill = "transparent", color = "black", size = 0.03, 
  #         data = . %>% group_by(c_autonoma) %>% summarise()) +
  coord_sf() +
  theme_void()
