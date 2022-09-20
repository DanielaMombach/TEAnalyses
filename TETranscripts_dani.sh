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
TEtranscripts --format BAM --mode multi -t RNAseq1.bam RNAseq2.bam -c CtlRNAseq1.bam CtlRNAseq.bam

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