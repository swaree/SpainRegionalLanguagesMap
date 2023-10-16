library(readxl)
library(stringr)
library(dplyr)
library(sf)
library(ggplot2)
library(maptools)
library(RColorBrewer)
library(ggmagnify)
library(ggnewscale)

# Lectura del fichero .shp
municipios <- read_sf(
  "./datos/lineas_limite/recintos_municipales_inspire_peninbal_etrs89/recintos_municipales_inspire_peninbal_etrs89.shp"
)

data_lenguas <- readxl::read_excel(
  path = "./datos/diccionario23.xlsx",
  range = cell_cols("D:M"),
  col_types = c("text", "text", rep("numeric", each=8))
)

# carxe <- read_sf(
#   "./datos/lineas_limite/carxe/POLYGON.shp"
# )

municipios = municipios %>%
  mutate(
    c_autonoma = stringr::str_sub(string = NATCODE, start = 3, end = 4),
    provincia  = stringr::str_sub(string = NATCODE, start = 5, end = 6),
    # municipio  = stringr::str_sub(string = NATCODE, start = 7, end = -1)
  ) %>%
  left_join(
    y = data_lenguas %>% select(NATCODE, ARANES, CATALA, EUSKERA, GALEGO),
    by = "NATCODE"
  )

aran <- c("34092525031", "34092525045", "34092525057",
          "34092525059", "34092525063", "34092525121",
          "34092525025", "34092525243", "34092525247")

ggplot(municipios) +
  geom_sf(fill = "gray80", color = "transparent", size = 0) +
  geom_sf(color = "transparent", size = 0, aes(fill = ARANES, alpha = ARANES)) +
  scale_fill_distiller(palette = "YlOrBr", na.value = "gray80", direction = 1) +
  geom_magnify(aes(from = NATCODE %in% aran),
                      to = c(0.2, 0.6, 43, 45),
                      colour = "gray70",
                      linewidth = 0,
                      shape = "outline",
                      proj.linetype = 1,
                      aspect = "fixed",
                      expand = 0,
  ) +
  # geom_sf(data = carxe, fill = "transparent", size = 0) +
  new_scale_fill() +
  geom_sf(fill = "gray80", color = "transparent", size = 0,
          data = . %>% group_by(provincia) %>% summarise()) +
  geom_sf(color = "transparent", size = 0, aes(fill = CATALA, alpha = CATALA)) +
  scale_fill_distiller(palette = "OrRd", na.value = "transparent", direction = 1) +
  new_scale_fill() +
  geom_sf(color = "transparent", size = 0, aes(fill = EUSKERA, alpha = EUSKERA)) +
  scale_fill_distiller(palette = "YlGn", na.value = "transparent", direction = 1) +
  new_scale_fill() +
  geom_sf(color = "transparent", size = 0, aes(fill = GALEGO, alpha = GALEGO)) +
  scale_fill_distiller(palette = "PuBu", na.value = "transparent", direction = 1) +
  geom_sf(fill = "transparent", color = "gray50", size = 0.03,
          data = . %>% group_by(provincia) %>% summarise()) +
  geom_sf(fill = "transparent", color = "black", size = 0.01,
          data = . %>% group_by(c_autonoma) %>% summarise()) +
  coord_sf() +
  theme_void()
