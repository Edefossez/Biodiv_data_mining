
######################################################################
######################################################################
############## hierachical clustering
library(vegan)
library(ape)
matrix_full$ID <- c(1:nrow(matrix_full))

matrix_full <- na.omit(matrix_full)
df <- matrix_full[,colnames(matrix_full) %in% c("temp","elevation","NDVI","precip")]

df <- apply(df,2,as.numeric)

dist_df <- vegdist(df, method = "euclidian") # method="man" # is a bit better
hclust_df<- hclust(dist_df, method = "complete")

dendro_df <-  as.phylo(hclust_df)


plot(dendro_df)

############ circular plot

ID <- as.factor(matrix_full$ID)
Landcover  <- as.factor(matrix_full$LC)
g2 <- split(ID, Landcover)

#################################################################################
################################################################################
library(ggtree)

tree_plot <- ggtree::groupOTU(dendro_df, g2,group_name = "grouper")

#################################################################################
################################################################################
library(randomcoloR)

cols <- distinctColorPalette(length(unique(Landcover))) ## several color
cols <- cols[1:length(unique(Landcover))]

#################################################################################
################################################################################

circ <- ggtree(tree_plot, aes(color = grouper), size = 2,layout = "circular") + 
  geom_tiplab(size = 3) +
  scale_color_manual(values = cols) 

circ 
