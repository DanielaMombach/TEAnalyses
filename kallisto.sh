# kallisto ##############################################################################################################
# index
ln -s /home/projects2/databases/gencode/release36/gencode.v36.transcripts.fa.gz
kallisto index -i geneSeq_v36.idx gencode.v36.transcripts.fa.gz 2>log_indexKalisto
    
# quant                              
# For single-end mode you supply the --single flag, as well as the -l and -s options (read_size=75-77 and read_size_sd=1)
# Important note: only supply one sample at a time to kallisto
kallisto quant -i geneSeq_v36.idx -o kallisto/output_37 --single -l 76 -s 1 -t 3 SRR14310037_SS.fastq.gz &
kallisto quant -i geneSeq_v36.idx -o kallisto/output_38 --single -l 76 -s 1 -t 3 SRR14310038_SS.fastq.gz &
kallisto quant -i geneSeq_v36.idx -o kallisto/output_39 --single -l 76 -s 1 -t 3 SRR14310039_SS.fastq.gz &
kallisto quant -i geneSeq_v36.idx -o kallisto/output_40 --single -l 76 -s 1 -t 3 SRR14310040_SS.fastq.gz &
kallisto quant -i geneSeq_v36.idx -o kallisto/output_41 --single -l 76 -s 1 -t 3 SRR14310041_SS.fastq.gz &
kallisto quant -i geneSeq_v36.idx -o kallisto/output_42 --single -l 76 -s 1 -t 3 SRR14310042_SS.fastq.gz &
kallisto quant -i geneSeq_v36.idx -o kallisto/output_43 --single -l 76 -s 1 -t 3 SRR14310043_SS.fastq.gz &
kallisto quant -i geneSeq_v36.idx -o kallisto/output_44 --single -l 76 -s 1 -t 3 SRR14310044_SS.fastq.gz &
kallisto quant -i geneSeq_v36.idx -o kallisto/output_45 --single -l 76 -s 1 -t 3 SRR14310045_SS.fastq.gz &
kallisto quant -i geneSeq_v36.idx -o kallisto/output_46 --single -l 76 -s 1 -t 3 SRR14310046_SS.fastq.gz &
kallisto quant -i geneSeq_v36.idx -o kallisto/output_47 --single -l 76 -s 1 -t 3 SRR14310047_SS.fastq.gz &
kallisto quant -i geneSeq_v36.idx -o kallisto/output_48 --single -l 76 -s 1 -t 3 SRR14310048_SS.fastq.gz &

# TX2gene #############################################################################################################
# Create mapping between transcripts and corresponding genes
echo "TXNAME,GENEID" > tx2gene.csv
awk -F "|" '{if(NR>1){print $1","$2}}' kallisto/output_37/abundance.tsv >> tx2gene.csv

# Process output of kallisto
for f in $(find . -type d -name "output*"); do
    awk -F "|" '{print $1$9}' $f/abundance.tsv > $f/final_abundance.tsv
done

# TXimport in R ########################################################################################################
setwd("/media/labdros/Daniela/srr_cispla")

# First, we locate the directory containing the files. 
dir <- "/media/labdros/Daniela/srr_cispla/kallisto"
list.files(dir)

# Next, we create a named vector pointing to the quantification files. 
samples <- read.table(file.path(dir, "samples.txt"), header = TRUE)
samples

# create tx2gene (https://hbctraining.github.io/DGE_workshop_salmon/lessons/01_DGE_setup_and_overview.html) - ENSEMBL
tx2gene <- read.delim("tx2gene_grch38_ens94.txt")
tx2gene

# for kallisto
library(tximport)
files <- file.path(dir, samples$run, "abundance.tsv")
files
file.exists(files)
names(files) <- paste0("sample", 1:6)
txi.kallisto.tsv <- tximport(files, type = "kallisto", tx2gene = tx2gene, ignoreTxVersion = TRUE)
head(txi.kallisto.tsv$counts)
write.table(txi.kallisto.tsv, file="A2780_txi.csv", sep = ",")

# DESeq2 in R #############################################################################################################
library(DESeq2)

## Input count table
counttable = read.csv("A2780_kallisto_counts.csv", header = TRUE, row.names = 1, sep = ",")
head(counttable)

## The dim must has only columns representing the samples
dim(counttable)

## colData creation
condition = c("control","control","control","treatment","treatment","treatment")
colData = data.frame(row.names=colnames(counttable), treatment=factor(condition, levels=c("control","treatment")))
colData      

counttable$counts.sample1 = as.numeric(counttable$counts.sample1)
counttable$counts.sample2 = as.numeric(counttable$counts.sample2)
counttable$counts.sample3 = as.numeric(counttable$counts.sample3)
counttable$counts.sample4 = as.numeric(counttable$counts.sample4)
counttable$counts.sample5 = as.numeric(counttable$counts.sample5)
counttable$counts.sample6 = as.numeric(counttable$counts.sample6)
counttable[is.na(counttable)] <- 0

## Differential expression analysis
dataset <- DESeqDataSetFromMatrix(countData = round(counttable), colData = colData, design = ~treatment)
dataset
dds = DESeq(dataset)
head(dds)
result = results(dds)
write.table(result, file="A2780_kallisto_deseq.csv", sep = ",")
