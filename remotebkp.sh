#!/bin/bash
#set -x
##########- CONF -##############
DIR_ORIG="/backup/exports"
MNT_DIR='//192.168.0.18/bkp-oracle'
CREDENTIALS='/dir/to/file/with/credentials'
###############################
function purgefiles(){
	if [ ! -f ./logs/remotebackup.log ] || [ ! -f ./logs/remotebackup.err ];then
		mkdir ./logs
		touch /logs/remotebackup.log
		touch /logs/remotebackup.err
		LOGARQ="./logs/remotebackup.log"
		LOGERR="./logs/remotebackup.err"
	else
		LOGARQ="./logs/remotebackup.log"
		LOGERR="./logs/remotebackup.err"
	fi

	dthoje=$(date +%Y%m%d)
	dtanohoje=$(date +%Y)
	dtmeshoje=$(date +%m)
	dtdiahoje=$(date +%d)
	dtdiacorte=$(date -d '-4day' +%d) 
	dtmescorte=$(date -d '-4day' +%m) 
	dtanocorte=$(date -d '-4day' +%Y) 
	echo "[!] Limpando $DIRBCK $dthoje" >> $LOGARQ
	dtcorte=$(echo $dtanocorte$dtmescorte$dtdiacorte)
	echo $dtcorte
	date +%d/%m%Y--%H:%M
	echo "[!] DATA de corte=$dtcorte" >> $LOGARQ
	for arq in /mnt/*
	do
        	IFS='/' read -r a b dtarq <<< $arq
		echo "DATA ARQ READ do arquivo $arq = $dtarq" >> $LOGARQ 2>>$LOGERR
        	dtanoarq=${dtarq:8:4}
	        dtmesarq=${dtarq:13:2}
	        dtdiaarq=${dtarq:16:2}
        	dtarq2=$dtanoarq$dtmesarq$dtdiaarq
        	if [ $dtarq2 -lt $dtcorte ]
	        then
			rm $arq >> $LOGARQ 2>>$LOGERR
                	echo "Killing the  $arq" >> $LOGARQ
		else
			echo "File $arq will live more few days: $dtarq2" | tee $LOGARQ
		fi
	done
}

function storage(){
	for fileful in $1/*
	do
		file=$( echo $fileful | cut -d '/' -f 4) 
		if [ !  -f /mnt/$file ]
		then 
			echo "[+] Copiando $file /mnt/"
			cp $fileful /mnt/
			echo "[+] The $file are safe now."
			echo "[*] Copia Realizada SRC: ${DIR_ORIG} > DST: ${MNT_DIR} aka /mnt/"
		else
			echo "[!] File $file are already safe"
		fi
	done
}

function cleanstuff(){
	case $1 in
	
	open)
		echo '[*] Montando a partição'
		mount -t cifs $MNT_DIR /mnt -o credentials=$CREDENTIALS
		;;
	close) 
		echo '[*] Fechando a partição'
		umount /mnt
		;;
	*) 
		echo 'come on, do notfuck with me' 
	esac
}

function main(){
	cleanstuff open	
	purgefiles
	storage $DIR_ORIG
	cleanstuff close
	exit 1 #or maybe 0? 
}
main
