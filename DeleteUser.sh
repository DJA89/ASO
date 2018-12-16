#!/bin/bash

u=0
usage="Usage: DeleteUser.sh [username]"

# detecció de opcions d'entrada: només son vàlids: sense paràmetres i -p

if [ $# -ne 0 ]; then
	if [ $# -eq 1 ]; then
			p=1
	else
		echo $usage; exit 1
	fi
else
	echo $usage; exit 1
fi

for file in `find /home -type f -user $1`; do
	echo $file
	aux=`cp $file /home/admin/aso/Escritorio/backup/`
done
