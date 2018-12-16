#!/bin/bash

p=0
t=0
t1=""
t2=""
dias=0

usage="Usage: BadUser.sh [-p] [-t]"

# detecció de opcions d'entrada: només son vàlids: sense paràmetres i -p

if [ $# -ne 0 ]; then
	if [ $# -eq 1 ]; then
		if [ $1 == "-p" ]; then
			p=1
		else
			echo $usage; exit 1
		fi
	elif [ $# -eq 2 ]; then
		if [ $1 == "-t" ]; then
			t=1
			t1=$2
			t2=${t1::-1}
			t1=${t1:${#t1} - 1}
			re='^[0-9]+$'
			if ! [[ $t2 =~ $re ]] || [[ $t1 != "d" && $t1 != "m" ]]; then
				echo $usage; exit 1
			fi
			if [ $t1 == "d" ]; then
				dias=$t2
			else
				dias=30*$t2
			fi
		else
			echo $usage; exit 1
		fi
	else
		echo $usage; exit 1
	fi
fi

for user in `cat /etc/passwd | cut -d: -f1`; do
	home=`cat /etc/passwd | grep "user\>" | cut -d: -f6`
	if [ -d $home ]; then
		num_fich=`find $home -type f -user $user | wc -l`
	else
		num_fic=0
	fi

	if [ $num_fich -eq 0 ]; then
		if [ $p -eq 1 ]; then
			user_proc=$((`ps -u $user | wc -l` - 1))
			if [ $user_proc -eq 0 ]; then
				echo "$user"
			fi
		elif [ $t -eq 0 ]; then
			echo "$user"
		fi
	fi

	if [ $t -eq 1 ]; then
		user_proc=$((`ps -u $user | wc -l` - 1))
		last_login=`lastlog -u $user -t $dias | wc -l`
		modified_files=`find $home -type f -user $user -mtime +$dias | wc -l`

		if [ $user_proc -eq 0 ] && [ $last_login -eq 0 ] && [ $modified_files -eq 0 ]; then
			echo "$user"
		fi
	fi
done
