#######################################
## Brazil-Hexagon-Wall-V.1. - Pimenta
#######################################
#install.packages("purrr")
#install.packages("magick")
library(purrr)
library(magick)
library(tidyverse)
library(raster)
library(sf)

# Select the country and the number of hexagons
# ccodes()
country <- "BRA" # GIN
width.size.hex <- 1.809 # 3071 quanto menor maior o # de hexagonos

# Download the Spatial Polygons of the selected country and it's gemetry with the `getData` function
c.shape <- getData("GADM", country = country, level = 0) %>%
  disaggregate() %>%
  geometry()


# Plot the country coordinates with `ggplot` and `geom_sf`
(plot1 <- ggplot() + geom_sf(data = st_as_sf(c.shape)))

# Draw the hexagon wall (beehive) with the defined width.size.ex and by using the
# sample point locations in (or on) a spatial object `spsample()` function
hex_points <- c.shape %>%
  spsample(type = "hexagonal", cellsize = width.size.hex)

as_tibble(hex_points@coords)

# Count the number of hexagon
hex = dim(as_tibble(hex_points@coords))[1]
cat(paste("Existem",hex," hexágonos desenhados."))

# Make SpatialPolygons object from GridTopology object (transforms the hex_points to SpatialPoly)
country_hex <- HexPoints2SpatialPolygons(hex_points, dx = width.size.hex)

# Superposition plot of the hexagon created and the country geometry coordinates at plot1
ggplot() + 
  geom_sf(data = st_as_sf(c.shape)) + 
  geom_sf(data = st_as_sf(country_hex), colour = "blue", fill = NA)

# Finally using the function hexwall() to fil lthe hexagon with the R package hexagon stickers
# besid
source("hexwall.R")
hexwall(
  "IMG/hex-rpack-stick",
  sticker_width = 200,
  coords = hex_points@coords,
  sort_mode = "colour"
)
