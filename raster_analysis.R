# Install and load necessary packages
install.packages(c("raster", "rgdal", "sf", "exactextractr"))
library(raster)
library(rgdal)
library(sf)
library(exactextractr)

# Load the raster and grid shapefile
lulc_raster <- raster("2018.tif")
grid_shapefile <- st_read("selected_grids.shp")

# Check CRS of both datasets
raster_crs <- crs(lulc_raster)
shapefile_crs <- st_crs(grid_shapefile)

# Transform the shapefile CRS to match the raster CRS if they are different
if (shapefile_crs != raster_crs) {
  grid_shapefile <- st_transform(grid_shapefile, raster_crs)
}

# Extract land use data for each grid using exact_extract
lulc_data <- exact_extract(lulc_raster, grid_shapefile)

# Function to calculate percentage of each land use type
calculate_percentage <- function(extracted_data) {
  if(length(extracted_data) == 0) {
    # If no data is returned, return NA for all percentages
    return(rep(NA, ncol(lulc_raster)))
  } else {
    # Combine all values into a single vector
    values <- unlist(extracted_data)
    
    # Remove NA values
    values <- values[!is.na(values)]
    
    # Count the number of each land use type
    land_use_counts <- table(values)
    
    # Calculate total cells
    total_cells <- sum(land_use_counts)
    
    # Calculate percentage
    land_use_percentage <- (land_use_counts / total_cells) * 100
    
    # Convert to data frame for easier combination later
    return(as.data.frame(t(land_use_percentage)))
  }
}

# Apply the function to each grid
percentage_list <- lapply(lulc_data, calculate_percentage)

# Combine the results with grid IDs
results <- data.frame(grid_id = grid_shapefile$grid_id)

# Find the index of the first non-empty element of percentage_list
first_non_empty_index <- NULL
for (i in seq_along(percentage_list)) {
  if (!is.null(percentage_list[[i]])) {
    first_non_empty_index <- i
    break
  }
}

# Check if any non-empty element was found
if (is.null(first_non_empty_index)) 
  { cat("No non-empty element found in percentage_list.")
} else {
  # Initialize results data frame with grid IDs and the same number of rows as the first non-empty element of percentage_list
  results <- data.frame(grid_id = grid_shapefile$grid_id[1:nrow(percentage_list[[first_non_empty_index]])])
  
  # Loop through each element in the percentage_list starting from the first_non_empty_index
  for(i in first_non_empty_index:length(percentage_list)) {
    # If percentage_list[[i]] is not empty
    if (!is.null(percentage_list[[i]])) {
      # Merge the results with grid IDs
      results <- merge(results, cbind(grid_id = grid_shapefile$grid_id[1:nrow(percentage_list[[i]])], percentage_list[[i]]), by = "grid_id", all.x = TRUE)
    } else {
      # If empty, create a data frame of NAs and combine with grid IDs
      empty_df <- data.frame(matrix(NA, ncol = ncol(percentage_list[[1]]), nrow = nrow(results)))
      colnames(empty_df) <- colnames(percentage_list[[1]])
      results <- merge(results, cbind(grid_id = grid_shapefile$grid_id[1:nrow(empty_df)], empty_df), by = "grid_id", all.x = TRUE)
    }
  }

 # Remove duplicate grid_id column
results <- results[, !duplicated(colnames(results))]

# View the results
print(results)

# Save the results (Optional)
write.csv(results, "land_use_percentages.csv", row.names = FALSE)

