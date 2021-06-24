#!/system/bin/sh
# Make android image by wahyu6070
MKE2FS=mke2fs
E2FSDROID=e2fsdroid
BLOCKSIZE=4096
ABOUT(){
	echo "usage :  mdroidimage.sh -t new -a A -s 683773 -f file_contexts -p system -i src_fir -o file_image"
	echo
	exit
	}
	if [[ $1 == -t ]] && [[ $2 == old ]]; then
	TYPE=old
	elif [[ $1 == -t ]] && [[ $2 == new ]]; then
	TYPE=new
	else
	ABOUT
	fi
	if [[ $3 == -a ]] && [[ $4 == A ]]; then
	SYEMLESS=A
	elif [[ $3 == -a ]] && [[ $4 == AB ]]; then
	SYEMLESS=AB
	else
	ABOUT
	fi
	if [[ $5 == -s ]] && [[ $6 -eq $6 ]]; then
	SIZE=${6}
	else
	ABOUT
	fi
	if [[ $7 == -f ]] && [[ -f $8 ]]; then
	FILE_CONTEXTS=$8
	else
	ABOUT
	fi
	if [[ $9 == -p ]] && [[ ${10} == system ]]; then
	PARTITIONS=system
	elif [[ $9 == -p ]] && [[ ${10} == vendor ]]; then
	PARTITIONS=vendor
	else
	ABOUT
	fi
	if [[ ${11} == -i ]] && [[ -d ${12} ]]; then
	INPUT=${12} 
	else
	ABOUT
	fi
	
	if [[ ${13} == -o ]]; then
	OUTPUT="${14}"
	else
	ABOUT
	fi
	
	SIZECON=$((SIZE / BLOCKSIZE))
	if [[ $TYPE == old ]]; then
		echo
	elif [[ $TYPE == new ]]; then
		if [[ $SYEMLESS == A ]]; then
			$MKE2FS -L $PARTITIONS -E android_sparse -t ext4 -b $BLOCKSIZE "$OUTPUT" $SIZECON
			$E2FSDROID -T 0 -S $FILE_CONTEXTS -f $INPUT -a /$PARTITIONS $OUTPUT
			echo "$E2FSDROID -T 0 -S $FILE_CONTEXTS -f $INPUT -a /$PARTITIONS $OUTPUT"
		elif [[ $SYEMLESS = AB ]]; then
		echo 
		fi
	
	fi