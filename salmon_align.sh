#Create Salmon Index
zcat original/REdiscoverTE/rollup_annotation/REdiscoverTE_whole_transcriptome_hg38-20/*.fa.gz > genome.fasta

salmon index \
	-t genome.fasta \
	--threads 64 \
	-i REdiscoverTE

#Align Samples to Salmon Index (single-end)
for f in /media/labdros/Daniela/srr_cispla/reads/*.fastq ; do

	echo $f

	base=${f%.fastq}
	echo $base

	/media/labdros/Daniela/salmon-1.9.0_linux_x86_64/bin/salmon quant --seqBias --gcBias \
		--index /media/labdros/Daniela/REdiscoverTE/REdiscoverTE \
		--libType A --unmatedReads ${f} \
		--validateMappings \
 	-o ${base}.salmon.REdiscoverTE \
		--threads 8

done

#Rollup / Aggregate Alignments to RE repName
echo -e "sample\tquant_sf_path" > /media/labdros/Daniela/srr_cispla/reads/REdiscoverTE.tsv
ls -1 /media/labdros/Daniela/srr_cispla/reads/*.salmon.REdiscoverTE/*_quant.sf | awk -F/ '{split($8,a,".");print a[1]"\t"$0}' >> /media/labdros/Daniela/srr_cispla/reads/REdiscoverTE.tsv

/media/labdros/Daniela/REdiscoverTE/rollup.R --metadata=/media/labdros/Daniela/srr_cispla/reads/REdiscoverTE.tsv --datadir=/media/labdros/Daniela/REdiscoverTE/original/REdiscoverTE/rollup_annotation/ --nozero --threads=8 --assembly=hg38 --outdir=/media/labdros/Daniela/srr_cispla/reads/REdiscoverTE_rollup/

#http://research-pub.gene.com/REdiscoverTEpaper/software/REdiscoverTE_README.html

#in R, RDS to csv table
library(edgeR)

x <- readRDS("GENE_1_raw_counts.RDS")
x
write.csv(x, "GENE_1_raw_counts.csv", row.names=FALSE)
GENE_1_raw_counts <- read.csv("GENE_1_raw_counts.csv")
GENE_1_raw_counts

x <- readRDS("RE_all_1_raw_counts.RDS")
x
write.csv(x, "RE_all_1_raw_counts.csv", row.names=FALSE)
RE_all_1_raw_counts <- read.csv("RE_all_1_raw_counts.csv")
RE_all_1_raw_counts

x <- readRDS("RE_all_repFamily_1_raw_counts.RDS")
x
write.csv(x, "RE_all_repFamily_1_raw_counts.csv", row.names=FALSE)
RE_all_repFamily_1_raw_counts <- read.csv("RE_all_repFamily_1_raw_counts.csv")
RE_all_repFamily_1_raw_counts
