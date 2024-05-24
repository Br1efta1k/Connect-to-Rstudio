# Clear console and remove variables
cat("\014") #clears the console
rm(list = ls()) #remove all variables

# Load required libraries
library(sf)
library(terra)
library(raster)
library(elevatr)
library(qgisprocess)
library(dplyr)

# Full paths to shapefiles
doubs_river_path <- "/home/botaoyuan/doubs_river.shp"
doubs_point_path <- "/home/botaoyuan/doubs_point.shp"

# Load Doubs river shapefile
doubs_river <- st_read(doubs_river_path)

# Transform Doubs river to UTM coordinate system
doubs_river_utm <- st_transform(doubs_river, 32631)

# Create a 2-km buffer along the Doubs river
doubs_river_buff <- st_buffer(doubs_river_utm, dist = 2000)

# Get bounding box of the buffer
bbox <- st_bbox(doubs_river_buff)

# Download DEM based on the bounding box
elevation <- get_elev_raster(bbox, z = 10)

# Crop DEM by Doubs river buffer
doubs_dem_utm_cropped <- crop(elevation, doubs_river_buff)

# Mask DEM by Doubs river buffer
doubs_dem_utm_masked <- mask(doubs_dem_utm_cropped, doubs_river_buff)

# Run QGIS algorithm to compute catchment area and slope
topo_total <- qgis_run_algorithm(
  alg = "sagang:sagawetnessindex",
  DEM = doubs_dem_utm_masked,
  SLOPE_TYPE = 1,
  SLOPE = tempfile(fileext = ".sdat"),
  AREA = tempfile(fileext = ".sdat"),
  .quiet = TRUE
)

# Extract file paths of slope and area rasters
topo_files <- c(
  AREA = tempfile(fileext = ".sdat"),
  SLOPE = tempfile(fileext = ".sdat")
)

# Convert topo_total to raster objects
topo_select <- lapply(topo_files, rast)

# Merge the extracted raster values into a single object
topo_merge <- do.call(c, topo_select)

# Load Doubs point shapefile
doubs_pts <- st_read(doubs_point_path)

# Transform points to UTM coordinate system
doubs_pts_utm <- st_transform(doubs_pts, 32631)

# Extract raster values for each point
topo_env <- extract(topo_merge, doubs_pts_utm)

# Combine extracted raster values with point data
doubs_env_df <- cbind(doubs_pts_utm, topo_env)

# Convert to sf object
doubs_env_sf <- st_as_sf(doubs_env_df)

# Write the resulting sf object to shapefile and csv
st_write(doubs_env_sf, "doubs_env.shp")
write.csv(doubs_env_df, "doubs_env.csv", row.names = FALSE)

