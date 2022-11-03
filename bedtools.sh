# gene coordinates: https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.gtf
# TE coordinates: https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_rm.out
# TEtranscripts TE index: https://labshare.cshl.edu/shares/mhammelllab/www-data/TEtranscripts/TE_GTF/GRCh38_GENCODE_rmsk_TE.gtf
# GENCODE gene annotation https://www.gencodegenes.org/human/ (Comprehensive gene anot CHR)

# To run Bedtools instersect we need to change the files to BED.
# BED files order: $chr $start $end $gene $. $strand (tab separated)

## gene file to BED
awk '$3 == "gene"' GCF_000001405.40_GRCh38.p14_genomic.gtf | awk '{print $1, $4, $5, $10, $6, $7}' | sed 's/[";]//g;s/ /\t/g' > GCF_000001405.40_GRCh38.p14_genomic_gene.bed
### upstream region
bash create_upstream_region.sh GCF_000001405.40_GRCh38.p14_genomic_gene.bed 3000 upstream_genes.bed

## GENCODE gene annotation
awk '$3 == "gene"' gencode.v42.annotation.gtf | awk '{print $1, $4, $5}' > gencode.v42.annotation.txt
awk '$3 == "gene"' gencode.v42.annotation.gtf | cut -f9 | cut -d';' -f1 | cut -d'"' -f2 > gencode.v42.annotation_ID.txt
awk '$3 == "gene"' gencode.v42.annotation.gtf | awk '{print $6, $7}' > gencode.v42.annotation_end.txt
paste gencode.v42.annotation.txt gencode.v42.annotation_ID.txt > gencode.v42.annotation_alm.txt
paste gencode.v42.annotation_alm.txt gencode.v42.annotation_end.txt > gencode.v42.annotation_done.txt
sed 's/ /\t/g' gencode.v42.annotation_done.txt > gencode.v42.annotation.bed
bash create_upstream_region.sh gencode.v42.annotation.bed 5000 gencode.v42.annotation_5kbupstream.bed

#create_upstream_region.sh
#!/bin/bash

#Author: Daniel Siqueira de Oliveira, feb/2022

#$1= input.bed
#$2= window size
#$3= output.bed

while IFS= read -r line
do
	window_size=$2        
	minimum=1
        scaff=$(cut -f1 <<< "$line")
        Start=$(cut -f2 <<< "$line")
        end=$(cut -f3 <<< "$line")
	final=$(cut -f4-6 <<< "$line")
        fita=$(cut -f6 <<< "$line")
        if [ "$fita" == + ]; then
                upstream=$(($Start - $window_size))
                        if [ "$upstream" -lt "$minimum" ]; then
                        upstream=1
                        fi
                echo -e "$scaff"'\t'"$upstream"'\t'"$Start"'\t'"$final" >> $3
                else
                upstream=$(($end + $window_size))
                echo -e "$scaff"'\t'"$end"'\t'"$upstream"'\t'"$final" >> $3
        fi
done < $1

## TE file to BED (remove header and C to -)
tail -n +4 GCF_000001405.40_GRCh38.p14_rm.out | awk '{print $5, $6, $7, $10, $15, $9}' | sed 's/C$/-/;s/ /\t/g' > GCF_000001405.40_GRCh38.p14_rm.bed

## TEtranscripts
awk '{print $1, $4, $5}' GRCh38_GENCODE_rmsk_TE.gtf > GRCh38_GENCODE_rmsk_TE.txt
cut -f9 GRCh38_GENCODE_rmsk_TE.gtf | cut -d';' -f1 | cut -d'"' -f2 > GRCh38_GENCODE_rmsk_TE_ID.txt
awk '{print $3, $7}' GRCh38_GENCODE_rmsk_TE.gtf > GRCh38_GENCODE_rmsk_TE_end.txt
paste GRCh38_GENCODE_rmsk_TE.txt GRCh38_GENCODE_rmsk_TE_ID.txt > GRCh38_GENCODE_rmsk_TE_alm.txt
paste GRCh38_GENCODE_rmsk_TE_alm.txt GRCh38_GENCODE_rmsk_TE_end.txt > GRCh38_GENCODE_rmsk_TE_done.txt
sed 's/ /\t/g' GRCh38_GENCODE_rmsk_TE_done.txt > GRCh38_GENCODE_rmsk_TE.bed

## telescope
awk '{print $1, $4, $5}' pcbi.1006453.s006.gtf > pcbi.1006453.s006.txt
cut -f9 pcbi.1006453.s006.gtf | cut -d';' -f1 | cut -d'"' -f2 > pcbi.1006453.s006_ID.txt
awk '{print $3, $7}' pcbi.1006453.s006.gtf > pcbi.1006453.s006_end.txt
paste pcbi.1006453.s006.txt pcbi.1006453.s006_ID.txt > pcbi.1006453.s006_alm.txt
paste pcbi.1006453.s006_alm.txt pcbi.1006453.s006_end.txt > pcbi.1006453.s006_done.txt
sed 's/ /\t/g' pcbi.1006453.s006_done.txt > pcbi.1006453.s006.bed
sed '/#/d' pcbi.1006453.s006.bed -i

# run bedtools intersect
bedtools intersect -wa -wb -a GCF_000001405.40_GRCh38.p14_genomic_gene.bed -b GCF_000001405.40_GRCh38.p14_rm.bed -s -f 0.2 > TEs_inside_gene.txt
bedtools intersect -wa -wb -a upstream_genes.bed -b GCF_000001405.40_GRCh38.p14_rm.bed -s -f 0.2 > TEs_upstream_gene.txt

# TE transcripts
bedtools intersect -wa -wb -a gencode.v42.annotation.bed -b GRCh38_GENCODE_rmsk_TE.bed -s -f 0.2 > TEs_inside_gene2.txt
bedtools intersect -wa -wb -a gencode.v42.annotation_5kbupstream.bed -b GRCh38_GENCODE_rmsk_TE.bed -s -f 0.2 > TEs_upstream_gene2.txt

# telescope
bedtools intersect -wa -wb -a gencode.v42.annotation.bed -b pcbi.1006453.s006.bed -s -f 0.2 > TEs_inside_gene3.txt
bedtools intersect -wa -wb -a gencode.v42.annotation_5kbupstream.bed -b pcbi.1006453.s006.bed -s -f 0.2 > TEs_upstream_gene3.txt

## use grep to find your TEs then your DEGs
