#!/bin/bash

set -e

# Declare an array of string with type
#single-end
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
                        
#paired-end
#declare -a StringArray=("SRR14310048.fastq"
#                        "SRR14310047.fastq"
#                        "SRR14310046.fastq"
#                        "SRR14310045.fastq"
#                        "SRR14310044.fastq"
#                        "SRR14310043.fastq"
#                        "SRR14310042.fastq"
#                        "SRR14310041.fastq"
#                        "SRR14310040.fastq"
#                        "SRR14310039.fastq"
#                        "SRR14310038.fastq"
#                        "SRR14310037.fastq")

DATA=/media/labdros/Daniela/srr_cispla/reads/
OUTPUT_STAR=/media/labdros/Daniela/srr_cispla/star_out
GENOME=/media/labdros/Daniela/GRCh38.primary_assembly.genome.fa/GRCh38.primary_assembly.genome.fa
GTF=/media/labdros/Daniela/gencode.v41.primary_assembly.annotation.gtf

#GENCODE: files marked with PRI (primary). Strongly recommended for mouse and human (fasta and GTF)

#mkdir -p "$OUTPUT_STAR"/star_index "$OUTPUT_STAR"/star_align "$OUTPUT_STAR"/counts "$OUTPUT_STAR"/star_align/stat

#/media/labdros/Daniela/STAR/STAR --runThreadN 8 --runMode genomeGenerate --genomeDir "$OUTPUT_STAR"/star_index --genomeFastaFiles "$GENOME" --sjdbGTFfile "$GTF" --sjdbOverhang 99 --genomeSAindexNbases 12

#single-end
for file in ${StringArray[@]}; do
	echo "Alignment "$file""
	/media/labdros/Daniela/STAR/STAR --genomeDir "$OUTPUT_STAR"/star_index \
		--runThreadN 16 \
		--readFilesIn "$DATA"/"$file" \
		--quantMode TranscriptomeSAM GeneCounts \
		--sjdbGTFfile "$GTF" \
		--outSAMtype BAM Unsorted \
		--outFilterMultimapNmax 100 \
		--winAnchorMultimapNmax 100 \
		--outFileNamePrefix "$OUTPUT_STAR"/star_align/"$file"_

	mv "$OUTPUT_STAR"/star_align/*final.out "$OUTPUT_STAR"/star_align/stat
	rm -R "$OUTPUT_STAR"/star_align/*tmp | rm "$OUTPUT_STAR"/star_align/*.out "$OUTPUT_STAR"/star_align/*tab
done

##paired-end
#for file in ${StringArray[@]}; do
#	echo "Alignment "$file""
#	/media/labdros/Daniela/STAR/STAR --genomeDir "$OUTPUT_STAR"/star_index \
#		--runThreadN 16 \
#		--readFilesIn "$DATA"/"${file%.fastq}"_1.fastq "$DATA"/"${file%.fastq}"_2.fastq \
#		--quantMode TranscriptomeSAM GeneCounts \
#		--sjdbGTFfile "$GTF" \
#		--outSAMtype BAM Unsorted \
#		--outFilterMultimapNmax 100 \
#		--winAnchorMultimapNmax 100 \
#		--outFileNamePrefix "$OUTPUT_STAR"/star_align/"${file%.fastq}"_
#
#	mv "$OUTPUT_STAR"/star_align/*final.out "$OUTPUT_STAR"/star_align/stat
#	rm -R "$OUTPUT_STAR"/star_align/*tmp | rm "$OUTPUT_STAR"/star_align/*.out "$OUTPUT_STAR"/star_align/*tab
#done

#for align in "$OUTPUT_STAR"/star_align/*.bam
#do
#	out=$(sed 's|/media.*align/||g' <<< "$align" | sed 's/_R_Aligned.*//g')
#	echo "Indexing "$out""
#	samtools index "$align"
#done

echo "DONE!!!!!"
