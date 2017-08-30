#!/bin/bash
#$ -N SampleID
#$ -j y
#$ -o SampleID.out
#$ -cwd
#$ -V
#$ -q all.q
#$ -M qgong@coh.org


mkfifo="/usr/bin/mkfifo"


pfx="SampleID"

rawdatadir="/net/isi-dcnl/ifs/user_data/jochan/Group/qgong/TCR/Rawdata"
r1="$rawdatadir/$pfx.R1.fastq.gz"
r2="$rawdatadir/$pfx.R2.fastq.gz"
mixcr="/home/qgong/bin/mixcr.jar"
java="/opt/jdk1.7.0_72/bin/java"

memory="16"


######################### 


echo "[`date`] Call CDR3 sequences using mixcr for $pfx "
echo "[`date`] Call XCR $pfx "
echo "[`date`] Building alignments using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr align $r1 $r2 $pfx.alignments.vdjca
echo "[`date`] Assembling clones using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr assemble $pfx.alignments.vdjca $pfx.clones.clns
echo "[`date`] Exporting clones to tab-delimited files using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr exportClones $pfx.clones.clns $pfx.clones.txt

echo "[`date`] Call TCR $pfx "
echo "[`date`] Building alignments using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr align --loci TRA,TRB,TRG,TRD $r1 $r2 $pfx.TCR.alignments.vdjca
echo "[`date`] Assembling clones using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr assemble $pfx.TCR.alignments.vdjca $pfx.TCR.clones.clns
echo "[`date`] Exporting clones to tab-delimited files using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr exportClones $pfx.TCR.clones.clns $pfx.TCR.clones.txt

echo "[`date`] Call TRA $pfx "
echo "[`date`] Building alignments using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr align --loci TRA $r1 $r2 $pfx.TRA.alignments.vdjca
echo "[`date`] Assembling clones using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr assemble $pfx.TRA.alignments.vdjca $pfx.TRA.clones.clns
echo "[`date`] Exporting clones to tab-delimited files using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr exportClones $pfx.TRA.clones.clns $pfx.TRA.clones.txt

echo "[`date`] Call TRB $pfx "
echo "[`date`] Building alignments using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr align --loci TRB $r1 $r2 $pfx.TRB.alignments.vdjca
echo "[`date`] Assembling clones using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr assemble $pfx.TRB.alignments.vdjca $pfx.TRB.clones.clns
echo "[`date`] Exporting clones to tab-delimited files using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr exportClones $pfx.TRB.clones.clns $pfx.TRB.clones.txt

echo "[`date`] Call TRG $pfx "
echo "[`date`] Building alignments using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr align --loci TRG $r1 $r2 $pfx.TRG.alignments.vdjca
echo "[`date`] Assembling clones using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr assemble $pfx.TRG.alignments.vdjca $pfx.TRG.clones.clns
echo "[`date`] Exporting clones to tab-delimited files using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr exportClones $pfx.TRG.clones.clns $pfx.TRG.clones.txt

echo "[`date`] Call TRD $pfx "
echo "[`date`] Building alignments using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr align --loci TRD $r1 $r2 $pfx.TRD.alignments.vdjca
echo "[`date`] Assembling clones using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr assemble $pfx.TRD.alignments.vdjca $pfx.TRD.clones.clns
echo "[`date`] Exporting clones to tab-delimited files using mixcr for $pfx "
$java -Xmx${memory}g -jar $mixcr exportClones $pfx.TRD.clones.clns $pfx.TRD.clones.txt

if [ ! -d "$pfx" ]; then
	mkdir $pfx
fi
mv $pfx.* $pfx

echo "[`date`] Job End "

