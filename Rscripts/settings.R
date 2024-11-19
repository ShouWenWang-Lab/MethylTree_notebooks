suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(purrr))
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(ggpubr))
suppressPackageStartupMessages(library(SingleCellExperiment))
suppressPackageStartupMessages(library(stringr))
suppressPackageStartupMessages(library(argparse))

# #########
# ## I/O ##
# #########
# print('step-0')

io <- list()


opts <- list()

opts$celltypes = c(
  "1",
  "2"
)

opts$celltype.colors = c(
  "1" = "#C6E2FF",
  "2" = "darkgreen"
)

opts$celltype2.colors = c(
  "1" = "#989898",
  "2" = "darkgreen"
)


opts$celltype3.colors = c(
  "1" = "#b63fba",
  "2" = "#BC8F8F"
)

opts$chr <- paste0("chr",c(1:19,"X","Y"))
opts$stages <- c("1")
opts$context.colors = c(
  "GC" = "#b63fba",
  "CG" = "#BC8F8F"
)

opts$stage.colors <- viridis::viridis(n=length(opts$stages))
names(opts$stage.colors) <- rev(opts$stages)
