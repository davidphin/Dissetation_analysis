# Install and load necessary packages
install.packages("ggplot2")
install.packages("corrplot")
install.packages("reshape2")
library(ggplot2)
library(corrplot)
library(reshape2)
library(scales)

# read dataset
data<-read.csv("Data_final.csv")

#corelation matrix
cormat=data[,-c(1,19)]

# Calculate the Pearson correlation matrix
correlation_matrix <- cor(cormat, method = "pearson")

# Visualize the correlation matrix with corrplot
corrplot(correlation_matrix, method = "circle")

# Reshape the correlation matrix
melted_correlation_matrix <- melt(correlation_matrix)



# Plot using ggplot2
ggplot(data = melted_correlation_matrix, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", midpoint = 0, limit = c(-1, 1), space = "Lab", name="Pearson\nCorrelation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  coord_fixed() +
  geom_text(aes(label = scales::percent(value, accuracy = 1)), color = "black", size = 4) +
  labs(title = "Correlation Matrix with Percentage Labels")
