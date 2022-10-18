# gene coordinates: https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.25_GRCh37.p13/GCF_000001405.25_GRCh37.p13_genomic.gtf.gz
# TE coordinates: Coord_TEs_GCF_000001405.25_GRCh37.p13_rm.bed

# To run Bedtools instersect we need to change the files to BED.

## gene file to BED
awk '$3 == "gene"' GCF_000001405.25_GRCh37.p13_genomic.gtf | awk '{print $1, $4, $5, $10, $6, $7}' | sed 's/[";]//g;s/ /\t/g' > GCF_000001405.25_GRCh37.p13_genomic.bed
### upstream region
bash create_upstream_region.sh GCF_000001405.25_GRCh37.p13_genomic.bed 3000 upstream_genes.bed

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

## TE file to BED já pronto
#sed -i 's/C$/-/;s/ /\t/g' GRCh38_GENCODE_rmsk_TE.gtf #prepare file (strand from C to)
#awk '{print $10, $4, $5, $7, $14, $16, $7}' GRCh38_GENCODE_rmsk_TE_bedtools.gtf > GRCh38_GENCODE_rmsk_TE.bed
#sed 's/;//g;s/"//g;s/ /\t/g'

# run bedtools intersect
bedtools intersect -wa -wb -a Homo_sapiens.GRCh38.96.bed -b Coord_TEs_GCF_000001405.25_GRCh37.p13_rm.bed -s -f 0.2 > TEs_inside_gene.txt
