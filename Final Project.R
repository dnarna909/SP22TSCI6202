


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
pbmc

# Visualization

