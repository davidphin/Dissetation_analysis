# Load required libraries
library(sf)
library(geosphere)

# Load the city center locations (assuming they are in a shapefile format)
city_centers <- st_read("C:/DAVID/WII/Dissertation/GIS/Vijay_Ramesh_LULC/City_centers.shp")

# Load centroids of grid cells
grid_centroids <- st_read("C:/DAVID/WII/Dissertation/GIS/Vijay_Ramesh_LULC/Centroid_selected_grids.shp")

# Check and transform the CRS if needed
if (!identical(st_crs(grid_centroids), st_crs(city_centers))) {
  grid_centroids <- st_transform(grid_centroids, st_crs(city_centers))
}

# Create an empty vector to store distances to the nearest city center
nearest_city_center_distance <- numeric(nrow(grid_centroids))

# Loop through each centroid and calculate the distance to the nearest city center
for (i in 1:nrow(grid_centroids)) {
  centroid <- grid_centroids[i, ]
  # Calculate distances from the centroid to all city centers
  distances_to_city_centers <- st_distance(centroid, city_centers)
  # Find the index of the nearest city center
  nearest_city_center_index <- which.min(distances_to_city_centers)
  # Store the distance to the nearest city center
  nearest_city_center_distance[i] <- distances_to_city_centers[nearest_city_center_index]
}

# Add distances to the centroids dataframe
grid_centroids$distance_to_nearest_city_center <- nearest_city_center_distance

# Print the first few rows of the dataframe
head(grid_centroids)

# Select only the column you want to export
distance_data <- grid_centroids %>% dplyr::select(distance_to_nearest_city_center)
distance_data= 

# Save the selected column to an Excel file
write.xlsx(distance_data, "C:/DAVID/WII/Dissertation/GIS/Vijay_Ramesh_LULC/CC_dist.xlsx", rowNames = FALSE)


# Load the openxlsx package
library(openxlsx)

# Check the structure of the data frame
str(distance_data)

# Example conversion: assuming 'your_list_column' is the list column
# Replace 'your_list_column' with the actual column name
distance_data$geometry <- sapply(distance_data$geometry, function(x) paste(unlist(x), collapse = ","))

# Ensure no columns are lists
str(distance_data)

# Export to Excel
write.xlsx(distance_data, "C:/DAVID/WII/Dissertation/GIS/Vijay_Ramesh_LULC/CC_dist.xlsx", rowNames = FALSE)



######
install.packages("openxlsx")
library(openxlsx)

# Assuming grid_centroids is your dataframe containing the results
#write.xlsx(grid_centroids, "C:/DAVID/WII/Dissertation/GIS/Vijay_Ramesh_LULC//output_R_file.xlsx", rowNames = FALSE)

# Check data types of all columns
column_types <- sapply(grid_centroids, class)

# Print column names and their data types
print(column_types)


# Remove the unwanted column
grid_centroids_cleaned <- grid_centroids[, !(names(grid_centroids) %in% "-geometry")]


# Write only those columns which are numeric to excel file
numeric_columns <- grid_centroids[, sapply(grid_centroids, is.numeric)]
# Save the cleaned dataframe to an Excel file
write.xlsx(grid_centroids_cleaned, "C:/DAVID/WII/Dissertation/GIS/Vijay_Ramesh_LULC//output_R_file.xlsx", rowNames = FALSE)

