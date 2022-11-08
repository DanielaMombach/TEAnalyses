#create_upstream_region.sh
#!/bin/bash

#Author: Daniel Siqueira de Oliveira, feb/2022

#usage: bash create_upstream_region.sh gencode.v42.annotation.bed 5000 gencode.v42.annotation_5kbupstream.bed

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
