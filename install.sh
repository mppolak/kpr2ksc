#!/bin/bash 

if [ $(which gcc) ]; then
	gcc -lm -o 3dec2frac 3dec2frac.c
	gcc -lm -o 3frac2num 3frac2num.c
	chmod +x kpr2ksc
elif [ $(which icc) ]; then
	icc -o 3dec2frac 3dec2frac.c
	icc -o 3frac2num 3frac2num.c
	chmod +x kpr2ksc
else
	echo "I cant find a C compiler, compile the two *.c files yourself"
fi
