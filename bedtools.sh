# gene coordinates: https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.gtf
# TE coordinates: https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_rm.out
# or TEtranscripts indexes

# To run Bedtools instersect we need to change the files to BED.

## gene file to BED
awk '$3 == "gene"' GCF_000001405.40_GRCh38.p14_genomic.gtf | awk '{print $1, $4, $5, $10, $6, $7}' | sed 's/[";]//g;s/ /\t/g' > GCF_000001405.40_GRCh38.p14_genomic_gene.bed
### upstream region
bash create_upstream_region.sh GCF_000001405.40_GRCh38.p14_genomic_gene.bed 3000 upstream_genes.bed

## TEtranscripts
awk '$3 == "CDS"' gene_GRCh38.gtf | awk '{print $4, $5, $1, $7, $7}' > gene_GRCh38.txt
awk '$3 == "CDS"' gene_GRCh38.gtf | cut -f9 | cut -d';' -f1 | cut -d'"' -f2 > gene_GRCh38_ID.txt
paste gene_GRCh38_ID.txt gene_GRCh38.txt > gene_GRCh38.bed 
sed 's/ /\t/g' gene_GRCh38.bed -i
bash create_upstream_region.sh gene_GRCh38.bed 5000 upstream_genes2.bed

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
awk '{print $4, $5, $1, $7, $7}' GRCh38_GENCODE_rmsk_TE.gtf > GRCh38_GENCODE_rmsk_TE.txt
cut -d';' -f1 GRCh38_GENCODE_rmsk_TE.gtf | cut -d'"' -f2 > GRCh38_GENCODE_rmsk_TE_ID.txt
paste GRCh38_GENCODE_rmsk_TE_ID.txt GRCh38_GENCODE_rmsk_TE.txt > GRCh38_GENCODE_rmsk_TE.bed 
sed 's/ /\t/g' GRCh38_GENCODE_rmsk_TE.bed -i

## telescope
awk '{print $4, $5, $1, $7, $7}' pcbi.1006453.s006.gtf > pcbi.1006453.s006.txt
cut -d';' -f2 pcbi.1006453.s006.gtf | cut -d'"' -f2 > pcbi.1006453.s006_ID.txt
paste pcbi.1006453.s006_ID.txt pcbi.1006453.s006.txt > pcbi.1006453.s006.bed
sed 's/ /\t/g' pcbi.1006453.s006.bed -i
sed '/#/d' pcbi.1006453.s006.bed -i

# run bedtools intersect
bedtools intersect -wa -wb -a GCF_000001405.40_GRCh38.p14_genomic_gene.bed -b GCF_000001405.40_GRCh38.p14_rm.bed -s -f 0.2 > TEs_inside_gene.txt
bedtools intersect -wa -wb -a upstream_genes.bed -b GCF_000001405.40_GRCh38.p14_rm.bed -s -f 0.2 > TEs_upstream_gene.txt

# TE transcripts
bedtools intersect -wa -wb -a gene_GRCh38.bed -b GRCh38_GENCODE_rmsk_TE.bed -s -f 0.2 > TEs_inside_gene2.txt
bedtools intersect -wa -wb -a upstream_genes2.bed -b GRCh38_GENCODE_rmsk_TE.bed -s -f 0.2 > TEs_upstream_gene2.txt

grep -f A2780_ids.txt TEs_inside_gene.txt
grep -f A2780_ids.txt TEs_upstream_gene.txt
