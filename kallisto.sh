#index - from kallisto pre build v96 (https://github.com/pachterlab/kallisto-transcriptome-indices/releases)

Usage: kallisto index [arguments] FASTA-files

#Required argument:
-i, --index=STRING          Filename for the kallisto index to be constructed 

#Optional argument:
-k, --kmer-size=INT         k-mer (odd) length (default: 31, max value: 31)
    --make-unique           Replace repeated target names with unique names
    
kallisto index -i index /media/labdros/Daniela/homo_sapiens/Homo_sapiens.GRCh38.cdna.all.fa
    
# quant
 
Usage: kallisto quant [arguments] FASTQ-files


#Required arguments:
-i, --index=STRING            Filename for the kallisto index to be used for
                              quantification
-o, --output-dir=STRING       Directory to write output to

Optional arguments:
    --bias                    Perform sequence based bias correction
-b, --bootstrap-samples=INT   Number of bootstrap samples (default: 0)
    --seed=INT                Seed for the bootstrap sampling (default: 42)
    --plaintext               Output plaintext instead of HDF5
    --fusion                  Search for fusions for Pizzly
    --single                  Quantify single-end reads
    --single-overhang         Include reads where unobserved rest of fragment is
                              predicted to lie outside a transcript
    --fr-stranded             Strand specific reads, first read forward
    --rf-stranded             Strand specific reads, first read reverse
-l, --fragment-length=DOUBLE  Estimated average fragment length
-s, --sd=DOUBLE               Estimated standard deviation of fragment length
                              (default: -l, -s values are estimated from paired
                               end data, but are required when using --single)
-t, --threads=INT             Number of threads to use (default: 1)
    --pseudobam               Save pseudoalignments to transcriptome to BAM file
    --genomebam               Project pseudoalignments to genome sorted BAM file
-g, --gtf                     GTF file for transcriptome information
                              (required for --genomebam)
-c, --chromosomes             Tab separated file with chromosome names and lengths
                              (optional for --genomebam, but recommended)
                              
# For single-end mode you supply the --single flag, as well as the -l and -s options, and list any number of FASTQ files, e.g

kallisto quant -i index -o output --single -l 200 -s 20 file1.fastq.gz file2.fastq.gz file3.fastq.gz
Important note: only supply one sample at a time to kallisto.

#TXimport
setwd("/media/labdros/Daniela/srr_cispla")

#First, we locate the directory containing the files. 
dir <- "/media/labdros/Daniela/srr_cispla/kallisto"
list.files(dir)

#Next, we create a named vector pointing to the quantification files. 
samples <- read.table(file.path(dir, "samples.txt"), header = TRUE)
samples

#create tx2gene
tx2gene <- read.delim("tx2gene_grch38_ens94.txt")
tx2gene

#kallisto
library(tximport)
files <- file.path(dir, samples$run, "abundance.tsv")
files
file.exists(files)
names(files) <- paste0("sample", 1:6)
txi.kallisto.tsv <- tximport(files, type = "kallisto", tx2gene = tx2gene, ignoreTxVersion = TRUE)
head(txi.kallisto.tsv$counts)
write.table(txi.kallisto.tsv, file="A2780_txi.csv", sep = ",")

#DESeq2
library(DESeq2)

##Input count table
counttable = read.csv("A2780_kallisto_counts.csv", header = TRUE, row.names = 1, sep = ",")
head(counttable)

##The dim must has only columns representing the samples
dim(counttable)

##colData creation
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

##Differential expression analysis
dataset <- DESeqDataSetFromMatrix(countData = round(counttable), colData = colData, design = ~treatment)
dataset
dds = DESeq(dataset)
head(dds)
result = results(dds)
write.table(result, file="A2780_kallisto_deseq.csv", sep = ",")

