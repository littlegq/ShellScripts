#!/opt/R-3.1.1/bin/Rscript
library(BiSeq)
data(promoters)

aitlcov <- "SampleID_AITL.10up.cov"
norcov <- "SampleID_Normal.10up.cov"

colData <- DataFrame(group = c("AITL"),row.names = c("SampleID_AITL"))
aitl <- readBismark(aitlcov, colData= colData)
colData <- DataFrame(group = c("Normal"),row.names = c("SampleID_Normal"))
nor <- readBismark(norcov, colData= colData)
rrbs <- combine(aitl,nor)
rrbs.rel <- rawToRel(rrbs)
rrbs.clust.unlim <- clusterSites(
	object = rrbs,
	perc.samples = 4/5,
	min.sites = 20,
	max.dist = 100)
ind.cov <- totalReads(rrbs.clust.unlim) > 0
quant <- quantile(totalReads(rrbs.clust.unlim)[ind.cov], 0.9)
rrbs.clust.lim <- limitCov(rrbs.clust.unlim, maxCov = quant)
predictedMeth <- predictMeth(object = rrbs.clust.lim)  # Time consuming
DMRs.2 <- compareTwoSamples(
	object = predictedMeth,
	sample1 = "SampleID_AITL",
    sample2 = "SampleID_Normal",
    minDiff = 0.3,
    max.dist = 100)
DMRs.anno <- annotateGRanges(
	object = DMRs.2,
	regions = promoters,
	name = 'Promoter',
	regionInfo = 'acc_no')
df <- data.frame(
	seqnames=seqnames(DMRs.anno),
    starts=start(DMRs.anno)-1,
	ends=end(DMRs.anno),
	median.meth.group1=elementMetadata(DMRs.anno)$median.meth.group1,
	median.meth.group2=elementMetadata(DMRs.anno)$median.meth.group2,
	median.meth.diff=elementMetadata(DMRs.anno)$median.meth.diff,
	Promoter=elementMetadata(DMRs.anno)$Promoter)
write.table(df, file="SampleID_AITL.SampleID_Normal_DMR.txt", quote=F, sep="\t", row.names=F)
