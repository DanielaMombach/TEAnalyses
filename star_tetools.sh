#!/bin/bash

set -e

# Declare an array of string with type
declare -a StringArray=("SRR14310048.fastq"
                        "SRR14310047.fastq"
                        "SRR14310046.fastq"
                        "SRR14310045.fastq"
                        "SRR14310044.fastq"
                        "SRR14310043.fastq"
                        "SRR14310042.fastq"
                        "SRR14310041.fastq"
                        "SRR14310040.fastq"
                        "SRR14310039.fastq"
                        "SRR14310038.fastq"
                        "SRR14310037.fastq")

DATA=/mnt/d/srr_cispla/reads/
OUTPUT_STAR=/mnt/d/srr_cispla/star_out
GENOME=/mnt/d/GRCh38.primary_assembly.genome.fa/GRCh38.primary_assembly.genome.fa
GTF=/mnt/d/gencode.v41.primary_assembly.annotation.gtf

#GENCODE: files marked with PRI (primary). Strongly recommended for mouse and human (fasta and GTF)

mkdir -p "$OUTPUT_STAR"/star_index "$OUTPUT_STAR"/star_align "$OUTPUT_STAR"/counts "$OUTPUT_STAR"/star_align/stat

/mnt/d/STAR/STAR --runThreadN 8 --runMode genomeGenerate --genomeDir "$OUTPUT_STAR"/star_index --genomeFastaFiles "$GENOME" --sjdbGTFfile "$GTF" --sjdbOverhang 99 --genomeSAindexNbases 12

for file in ${StringArray[@]}; do
	echo "Alignment "$file""
	STAR --genomeDir "$OUTPUT_STAR"/star_index \
		--runThreadN 16 \
		--readFilesIn "$file" \
		--quantMode TranscriptomeSAM GeneCounts \
		--sjdbGTFfile "$GTF" \
		--outSAMtype BAM Unsorted \
		--outFilterMultimapNmax 50
		--winAnchorMultimapNmax 50
		--outFileNamePrefix "$OUTPUT_STAR"/star_align/"$file"_

	mv "$OUTPUT_STAR"/star_align/*final.out "$OUTPUT_STAR"/star_align/stat
	rm -R "$OUTPUT_STAR"/star_align/*tmp | rm "$OUTPUT_STAR"/star_align/*.out "$OUTPUT_STAR"/star_align/*tab
done

#for align in "$OUTPUT_STAR"/star_align/*.bam
#do
#	out=$(sed 's|/media.*align/||g' <<< "$align" | sed 's/_R_Aligned.*//g')
#	echo "Indexing "$out""
#	samtools index "$align"
#    featureCounts -B -p -a "$GTF" -C -T 16 "$align" -o "$OUTPUT_STAR"/counts/"$out".count --fracOverlap 1
#	htseq-count "$align" "$DATA"/"$GTF" --order pos -s reverse > "$OUTPUT_STAR"/counts/"$out".count
done

#for file in ${StringArray[@]}; do
#       echo -e "\n*---------- COUNT TE : ${file}"
#       python3 "$TETOOLS" -bowtie2 -rosette "$ROSETTETXT" -column 2 -TE_fasta "$ROSETTEFASTA" -count "$DIRCOUNTTE"/"$file""_count.txt" -RNA "$DIRFASTQ"/"$file""1_val_1.fq.gz" -RNApair "$DIRFASTQ"/"$file""2_val_2.fq.gz" -insert 300

#done

echo "DONE!!!!!"
