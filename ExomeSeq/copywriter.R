#!/usr/bin/env Rscript

library(CopywriteR)

# preCopywriteR(output.folder = file.path("./"),
#              bin.size = 50000,
#              ref.genome = "hg19",
#              prefix = "chr")
bp.param <- SnowParam(workers = 8, type = "SOCK")
samples <- list.files(path = "../BAM", pattern = "recal.bam$", full.names = TRUE)
controls <- samples
sample.control <- data.frame(samples,controls)
CopywriteR(sample.control = sample.control,
           destination.folder = file.path("."),
           reference.folder = file.path(".", "hg19_100kb_chr"),
           bp.param = bp.param,
           capture.regions.file = "Agilent_covered.bed")
plotCNA(destination.folder = file.path("."))
