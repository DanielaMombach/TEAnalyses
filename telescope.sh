#installation
conda create -n telescope_env python=3.6 future pyyaml cython=0.29.7 \
  numpy=1.16.3 pandas=1.1.3 scipy=1.2.1 pysam=0.15.2 htslib=1.9 intervaltree=3.0.2

conda activate telescope_env
conda install -c bioconda telescope
telescope assign -h

#testing
telescope test #only works without bulk
telescope assign #with file paths shown above

#run for each SRR
telescope assign SRR14310037.fastq_Aligned.out.bam /media/labdros/Daniela/pcbi.1006453.s006.gtf

#get same ids in all
#get the ids
cut -f1 telescope-telescope_report_37.tsv telescope-telescope_report_38.tsv telescope-telescope_report_39.tsv telescope-telescope_report_43.tsv telescope-telescope_report_44.tsv telescope-telescope_report_45.tsv | sed 's/"//g' | sort | uniq -c | sed 's/^[ \t]*//;s/ /\t/' | sort -k1 -h | grep ^6 | cut -f2 > em_todos.txt

#get ids and counts
  for tab in telescope-telescope_report_37.tsv telescope-telescope_report_38.tsv telescope-telescope_report_39.tsv telescope-telescope_report_43.tsv telescope-telescope_report_44.tsv telescope-telescope_report_45.tsv; do grep -w -f em_todos.txt $tab | cut -f1,3 | sed 's/\t/,/' > counts_${tab}; done

#conferir
for tab in telescope-telescope_report_37.tsv telescope-telescope_report_38.tsv telescope-telescope_report_39.tsv telescope-telescope_report_43.tsv telescope-telescope_report_44.tsv telescope-telescope_report_45.tsv; do grep -c -f em_todos.txt $tab ;done

#DESeq2
library(DESeq2)

##Input count table
counttable = read.csv("A2780_counts.csv", header = TRUE, row.names = 1, sep = ",")
head(counttable)

##The dim must has only columns representing the samples
dim(counttable)

##colData creation
condition = c("control","control","control","treatment","treatment","treatment")
colData = data.frame(row.names=colnames(counttable), treatment=factor(condition, levels=c("control","treatment")))
colData      

##Differential expression analysis
dataset <- DESeqDataSetFromMatrix(countData = round(counttable), colData = colData, design = ~treatment)
dataset
dds = DESeq(dataset)
head(dds)
result = results(dds)
write.table(result, file="A2780xA2780t_deseq.csv", sep = ",")
