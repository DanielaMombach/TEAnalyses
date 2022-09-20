#Rodei um comando por vez

#/mnt/d/SalmonTE/SalmonTE.py index --ref_name=hs --input_fasta=GRCh37.p13.genome.fa --te_only #(https://github.com/hyunhwan-jeong/SalmonTE/wiki/How-to-build-a-customized-index)

#A2780  
/mnt/d/SalmonTE/SalmonTE.py quant --reference=hs --outpath=/mnt/d/A2780_out1_SalmonTE --num_threads=8 --exprtype=count /mnt/d/srr_cispla/reads

#Acis
/mnt/d/SalmonTE/SalmonTE.py quant --reference=hs --outpath=/mnt/d/Acis_out1_SalmonTE --num_threads=8 --exprtype=count /mnt/d/srr_cispla/reads2
  
#Before you run test mode, you should modify condition.csv file which is stored in the outpath. Colocar control e treatment.

#A2780
/mnt/d/SalmonTE/SalmonTE.py test --inpath=/mnt/d/A2780_out1_SalmonTE --outpath=/mnt/d/A2780_out2_SalmonTE --tabletype=xls --figtype=png --analysis_type=DE --conditions=control,treatment

#Acis
/mnt/d/SalmonTE/SalmonTE.py test --inpath=/mnt/d/Acis_out1_SalmonTE --outpath=/mnt/d/Acis_out2_SalmonTE --tabletype=xls --figtype=png --analysis_type=DE --conditions=control,treatment