#!/bin/bash -e

if [ $(which gcc) ]; then
	gcc -lm -o 3dec2frac 3dec2frac.c
	gcc -lm -o 3frac2num 3frac2num.c
	chmod +x kpr2ksc
	echo
	echo "If you didnt see any errors, the installation finished correctly"
	echo
elif [ $(which icc) ]; then
	icc -o 3dec2frac 3dec2frac.c
	icc -o 3frac2num 3frac2num.c
	chmod +x kpr2ksc
	echo
	echo "If you didnt see any errors, the installation finished correctly"
	echo

else
	echo
	echo "I cant find a C compiler, compile the two *.c files yourself"
	echo
fi
