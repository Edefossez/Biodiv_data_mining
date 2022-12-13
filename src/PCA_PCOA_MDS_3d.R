

library(ggfortify)
matrix_full <- na.omit(matrix_full)
df <- matrix_full[,colnames(matrix_full) %in% c("temp","elevation","NDVI","precip")]

df <- apply(df,2,as.numeric)

pca_res <- prcomp(df, scale. = TRUE)

autoplot(pca_res)

##########################################################################################
##########################################################################################


autoplot(pca_res, data = matrix_full, colour = 'LC',
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 3)

##########################################################################################
##########################################################################################

pca_plot <- autoplot(pca_res, data = matrix_full, colour = 'LC',
                     loadings = TRUE, loadings.colour = 'black',
                     loadings.label = TRUE, loadings.label.size = 3)

pca_plot + theme_classic()

##########################################################################################
##########################################################################################


autoplot(pca_res, data = matrix_full, colour = 'LC',
         loadings = TRUE, loadings.colour = 'black',
         loadings.label = TRUE, loadings.label.size = 3, frame = TRUE) + theme_classic()


##########################################################################################
##########################################################################################


autoplot(pca_res, data = matrix_full, colour = 'LC',
         loadings = TRUE, loadings.colour = 'black',
         loadings.label = TRUE, loadings.label.size = 3, frame = TRUE, frame.type = 'norm') + theme_classic()

##########################################################################################
##########################################################################################
##########################################################################################
##########################################################################################
##########################################
##########################################


row.names(df) <- c(1:nrow(matrix_full))
library(vegan)

dist_metabo <- vegdist(df, method = "euclidian")  # method="man" # is a bit better
D3_data_dist <- cmdscale(dist_metabo, k = 3)
D3_data_dist <- data.frame(D3_data_dist)


cols <- matrix_full$LC

PCOA <- ggplot(D3_data_dist, aes(x = X1, y = X2, color = cols)) +
  geom_point() + ggtitle("my project") +
  theme_classic()
PCOA

##interactive 

intercative_pcao <- ggplotly(PCOA)


##########################################################################################
##########################################################################################
#### 3D

library(plotly)
PCAO_3D <- plot_ly(
  x = D3_data_dist$X1, y = D3_data_dist$X2, z = D3_data_dist$X3, text = ~ cols,
  type = "scatter3d", mode = "markers", color = cols)