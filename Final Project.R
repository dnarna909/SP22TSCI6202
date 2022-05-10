


# DOWNLOAD FILE
library(utils)
download.file("https://cf.10xgenomics.com/samples/cell/pbmc3k/pbmc3k_filtered_gene_bc_matrices.tar.gz",
              destfile = "./PBMC3K.tar.gz")
untar("./PBMC3K.tar.gz", exdir = "./data/PBMC_shiny_test")


# Creat picture
library(dplyr)
library(Seurat)
library(patchwork)

# Load the PBMC dataset
pbmc_small

sc_data <- if(file.exists('REALDATA.rdata')) {
  import('REALDATA.rdata')} else {
pbmc_small}


# Visualization
features <- c("LYZ", "CCL5", "IL32", "PTPRCAP", "FCGR3A", "PF4")

# Ridge plots - from ggridges. Visualize single cell expression distributions in each cluster
RidgePlot(sc_data, features = features, ncol = 2)


# Violin plot - Visualize single cell expression distributions in each cluster
VlnPlot(sc_data, features = features)

# Feature plot - visualize feature expression in low-dimensional space
FeaturePlot(sc_data, features = features)

# Dot plots - the size of the dot corresponds to the percentage of cells expressing the
# feature in each cluster. The color represents the average expression level
DotPlot(sc_data, features = features) + RotatedAxis()


# Single cell heatmap of feature expression
DoHeatmap(subset(sc_data, downsample = 100), features = features, size = 3)

# Plot a legend to map colors to expression levels
FeaturePlot(sc_data, features = "MS4A1")

# Adjust the contrast in the plot
FeaturePlot(sc_data, features = "MS4A1", min.cutoff = 1, max.cutoff = 3)

# Calculate feature-specific contrast levels based on quantiles of non-zero expression.
# Particularly useful when plotting multiple markers
FeaturePlot(sc_data, features = c("MS4A1", "PTPRCAP"), min.cutoff = "q10", max.cutoff = "q90")

# Visualize co-expression of two features simultaneously
FeaturePlot(sc_data, features = c("MS4A1", "CD79A"), blend = TRUE)

VlnPlot(sc_data, features = "percent.mt", split.by = "groups")

plot <- FeaturePlot(sc_data, features = "MS4A1")
test <- HoverLocator(plot = plot, information = FetchData(sc_data, vars = c("ident", "PC_1", "nFeature_RNA")))



library(ShinyCell)
scConf = createConfig(sc_data)
makeShinyApp(sc_data, scConf, gene.mapping = TRUE,
             shiny.title = "ShinyCell Quick Start")













