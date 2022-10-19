# gene coordinates: https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.gtf
# TE coordinates: https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_rm.out

# To run Bedtools instersect we need to change the files to BED.

## gene file to BED
awk '$3 == "gene"' GCF_000001405.40_GRCh38.p14_genomic.gtf | awk '{print $1, $4, $5, $10, $6, $7}' | sed 's/[";]//g;s/ /\t/g' > GCF_000001405.40_GRCh38.p14_genomic_gene.bed
### upstream region
bash create_upstream_region.sh GCF_000001405.40_GRCh38.p14_genomic_gene.bed 3000 upstream_genes.bed

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

# run bedtools intersect
bedtools intersect -wa -wb -a GCF_000001405.40_GRCh38.p14_genomic_gene.bed -b GCF_000001405.40_GRCh38.p14_rm.bed -s -f 0.2 > TEs_inside_gene.txt
bedtools intersect -wa -wb -a upstream_genes.bed -b GCF_000001405.40_GRCh38.p14_rm.bed -s -f 0.2 > TEs_upstream_gene.txt
