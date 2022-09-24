#usage: TEtranscripts -t treatment sample [treatment sample ...]
#                     -c control sample [control sample ...]
#                     --GTF genic-GTF-file
#                     --TE TE-GTF-file
#                     [optional arguments]
#
#Required arguments:
#  -t | --treatment [treatment sample 1 treatment sample 2...]
#     Sample files in group 1 (e.g. treatment/mutant), separated by space
#  -c | --control [control sample 1 control sample 2 ...]
#     Sample files in group 2 (e.g. control/wildtype), separated by space
#  --GTF genic-GTF-file  GTF file for gene annotations
#  --TE TE-GTF-file      GTF file for transposable element annotations

#If BAM files are unsorted, or sorted by queryname:
/usr/local/bin/TEtranscripts --format BAM --mode multi -t SRR14310043.fastq_Aligned.out.bam SRR14310044.fastq_Aligned.out.bam SRR14310045.fastq_Aligned.out.bam -c SRR14310037.fastq_Aligned.out.bam SRR14310038.fastq_Aligned.out.bam SRR14310039.fastq_Aligned.out.bam --GTF /media/labdros/Daniela/gene_GRCh38.gtf --TE  /media/labdros/Daniela/GRCh38_GENCODE_rmsk_TE.gtf

#usage: TEcount -b RNAseq BAM
#               --GTF genic-GTF-file
#               --TE TE-GTF-file
#               [optional arguments]
#
#Required arguments:
#  -b | --BAM alignment-file  RNAseq alignment file (BAM preferred)
#  --GTF genic-GTF-file       GTF file for gene annotations
#  --TE TE-GTF-file           GTF file for transposable element annotations

#If BAM files are unsorted, or sorted by queryname:
TEcount --format BAM --mode multi -b RNAseq.bam
