#installation
conda create -n telescope_env python=3.6 future pyyaml cython=0.29.7 \
  numpy=1.16.3 pandas=1.1.3 scipy=1.2.1 pysam=0.15.2 htslib=1.9 intervaltree=3.0.2

conda activate telescope_env
conda install -c bioconda telescope
telescope assign -h

#testing
telescope test #only works without bulk
telescope assign #with file paths shown above


