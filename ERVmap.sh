#HG38 primary assembly fasta	ensembl	ref/Bowtie2_genome/genome.fa AND ref/bwa_genome/genome.fa
#HG38 comprehensive gene annotation (gtf)	ensembl	ref/genes.gtf

BWA index files: bwa index -p ref/bwa_genome/genome ref/bwa_genome/genome.fa
Bowtie index files: bowtie2-build ref/Bowtie2_genome/genome.fa ref/Bowtie2_genome/genome

conda activate dani
bash ERVmap_auto.sh /media/labdros/Daniela/srr_cispla/reads
