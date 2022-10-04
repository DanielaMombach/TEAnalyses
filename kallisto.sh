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

# TX import
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("tximport")
BiocManager::install("rhdf5")

files <- file.path(dir, "kallisto_boot", samples$run, "abundance.h5")
names(files) <- paste0("sample", 1:6)
txi.kallisto <- tximport(files, type = "kallisto", txOut = TRUE)
head(txi.kallisto$counts)

#DESeq2
#An example of creating a DESeqDataSet for use with DESeq2 (Love, Huber, and Anders 2014):

library(DESeq2)
#The user should make sure the rownames of sampleTable align with the colnames of txi$counts, if there are colnames. The best practice is to read sampleTable from a CSV file, and to construct files from a column of sampleTable, as was shown in the tximport examples above.

sampleTable <- data.frame(condition = factor(rep(c("A", "B"), each = 3)))
rownames(sampleTable) <- colnames(txi$counts)
dds <- DESeqDataSetFromTximport(txi, sampleTable, ~condition)
# dds is now ready for DESeq() see DESeq2 vignette
