# Load required libraries
library(raster)
library(sf)

# Load the forest class layer
forest_raster <- raster("C:/DAVID/WII/Dissertation/GIS/Vijay_Ramesh_LULC/shola_1984.tif")

# Load centroids of grid cells
grid_centroids <- st_read("C:/DAVID/WII/Dissertation/GIS/Vijay_Ramesh_LULC/Centroid_selected_grids.shp")

# Convert centroids to raster
grid_raster <- rasterize(grid_centroids, forest_raster, field = "GridID")

# Calculate Euclidean distance to the nearest forest patch
distance_raster <- distance(grid_raster)

# Convert raster to spatial points
distance_points <- rasterToPoints(distance_raster, spatial = TRUE)

# Convert grid centroids to sf object
grid_centroids_sf <- st_as_sf(grid_centroids)

# Extract distances to forest patches for each centroid
distances <- raster::extract(distance_raster, grid_centroids_sf)

# Add distances to the centroids dataframe
grid_centroids$distance_to_forest <- distances

# Print the first few rows of the dataframe
head(grid_centroids)


install.packages("openxlsx")
library(openxlsx)

# Assuming grid_centroids is your dataframe containing the results
write.xlsx(grid_centroids, "path/to/output_file.xlsx", row.names = FALSE)
