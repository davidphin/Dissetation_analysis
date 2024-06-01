
#check distribution of data
hist(data$Avg.Richness)
hist(data$Total.Abundance)
shapiro.test(data$Total.Abundance)
shapiro.test(data$Avg.Richness)

## Univariate GLM
glm=glm(data$Avg.Richness~data$X.Shola_forest, family= gaussian)
summary(glm)

glm_1=glm(data$Avg.Richness~data$X.Agriculture, family= gaussian)
summary(glm_1)


glm_2=glm(data$Avg.Richness~data$X.Shola_grassland, family= gaussian)
summary(glm_2)

glm_3=glm(data$Avg.Richness~data$X.Invasive_plantation, family= gaussian)
summary(glm_3)

glm_4=glm(data$Avg.Richness~data$X.Settlements, family= gaussian)
summary(glm_4)

glm_5= glm(data$Avg.Richness~ data$X.Tea_plantations, family= gaussian)
summary(glm_5)

glm_6= glm(data$Avg.Richness~ data$Dist_CC..m., family= gaussian)
summary(glm_6)

glm_7= glm(data$Avg.Richness~ data$Distance_shola, family= gaussian)
summary(glm_7)

glm_8= glm(data$Avg.Richness~ data$Avg.duration..min., family= gaussian)
summary(glm_8)






