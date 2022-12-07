# To run Bedtools instersect we need to change the files to BED.
# BED files order: $chr $start $end $gene $. $strand (tab separated)
annot2BED.ipynb

## upstream region
bash create_upstream_region.sh gencode.v36.annotation.bed 5000 gencode.v36.annotation_5kbupstream.bed

# telescope
bedtools intersect -wa -wb -a gencode.v36.annotation_python.bed -b pcbi.1006453.s006_python.bed -s -f 0.2 > TEs_inside_gene_tel.txt
bedtools intersect -wa -wb -a gencode.v36.annotation_5kbupstream.bed -b pcbi.1006453.s006_python.bed -s -f 0.2 > TEs_upstream_gene_tel.txt

## REdiscoverTE
# rediscoverBED.py = plus and minus bed files
bedtools intersect -wa -wb -a gencode.v36.annotation_python.bed -b  rmsk_plus.bed -s -f 0.2 > TEs_inside_gene_re.txt
bedtools intersect -wa -wb -a gencode.v36.annotation_python.bed -b  rmsk_min.bed -s -f 0.2 > TEs_inside_gene_rem.txt
bedtools intersect -wa -wb -a gencode.v36.annotation_5kbupstream.bed -b  rmsk_plus.bed -s -f 0.2 > TEs_upstream_gene_re.txt
bedtools intersect -wa -wb -a gencode.v36.annotation_5kbupstream.bed -b  rmsk_min.bed -s -f 0.2 > TEs_upstream_gene_rem.txt

## use grep to find your TEs then your DEGs
