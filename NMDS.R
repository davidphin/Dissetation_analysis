# Install and load the vegan package if you haven't already
install.packages("vegan")
library(vegan)

sp_site_data=read.csv("Sp_site_matrix.csv", sep=",")

 # Remove any missing values if present
data_complete <- na.omit(sp_site_data)

# Check the data types of variables in your dataframe
str(data_complete)

# Select only numeric variables
numeric_data <- data_complete[, sapply(data_complete, is.numeric)]

# Run NMDS
nmds_result <- metaMDS(numeric_data)

# Summary of NMDS result
summary(nmds_result)

# Plot NMDS
plot(nmds_result)



