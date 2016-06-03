#!/bin/bash 

mkdir kpr2ksc

echo "#include <stdio.h>
#include <math.h>
int main()
{

	float eps=0.0001;

	float inp, x, n, min_l, min_m, max_l, max_m, mid_l, mid_m;
	int num=1;
	while(scanf(\"%f\", &x)!=EOF)
	{
		n=floor(x);
		x-=n;
		min_l=0;
		min_m=1;
		max_l=1;
		max_m=1;

		while(1)
		{
			mid_l=min_l+max_l;
			mid_m=min_m+max_m;
			if(x<eps) {printf(\"0/1 \"); break;}
			else if(x>1-eps) {printf(\"1/1 \"); break;}
			else if(mid_m*(x+eps)<mid_l)
			{	
				max_l=mid_l;
				max_m=mid_m;
			}
			else if (mid_m*(x-eps)>mid_l)
			{
				min_l=mid_l;
				min_m=mid_m;
			}
			else 
			{
				printf(\"%.0f/%.0f \", n*mid_m+mid_l, mid_m);
				break;
			}
		}
		if(num==3) 
		{
			printf(\"\n\");
			num=0;
		}
		num=num+1;
	}
	return 0;
}" > kpr2ksc/3dec2frac.c

echo "#include <stdio.h>
#include <math.h>

int euklid(int a, int b)
{
	int c;
	while(b!=0)
	{
		c=a%b;
		a=b;
		b=c;
	}
	return a;
}

int main()
{
	int a,b,c,d, lines, i;
	scanf(\"%d\",&lines);
	for(i=1;i<=lines;i++)
	{
		scanf(\"%d %d %d\", &a, &b, &c);
		if(a==0) a=1;
		if(b==0) b=1;
		if(c==0) c=1;
		d=a*b/euklid(a,b);
		printf(\"%d\n\", c*d/euklid(c,d));
	}
	return 0;
}" > kpr2ksc/3frac2num.c

echo "#!/bin/bash

if [ -z \$1 ] || [ -z \$2 ] || [ \"\$1\" == \"-h\" ]
then
  echo
  echo \"Usage: \$(echo \$(pwd))/\`basename \$0\` [name of klist_band file] [multiplicity in X:Y:Z format]\"
  echo \"Example: \$(echo \$(pwd))/\`basename \$0\` GaAs.klist_band 3:2:5\"
  echo
  echo \"After execution, your klist file will be renamed with *_backup\"
  echo \"and the modified klist_file will replace your initial file\"
  echo
  exit 0
fi

multx=\$(echo \$2 | awk -F':' '{print \$1}')
multy=\$(echo \$2 | awk -F':' '{print \$2}')
multz=\$(echo \$2 | awk -F':' '{print \$3}')
PRIM_PATH=\$1

cat \$PRIM_PATH | cut -c 11- | head -n -1 | awk -v mx=\$multx -v my=\$multy -v mz=\$multz '{a=\$1*mx/\$4; b=\$2*my/\$4; c=\$3*mz/\$4; while(sqrt(a*a)>0.5) {if(a>0) {a=a-1} else {a=a+1}} while(sqrt(b*b)>0.5) {if(b>0) {b=b-1} else {b=b+1}} while(sqrt(c*c)>0.5) {if(c>0) {c=c-1} else {c=c+1}}; printf(\"%10f %10f %10f\n\",a,b,c)}' > red_path_all

awk '!a[\$0]++' red_path_all > red_path

./3dec2frac < red_path | awk '{print \$1\" \"\$2\" \"\$3}' > frac_path

cat frac_path | awk -F'[/ ]' '{print \$1\" \"\$3\" \"\$5}' > numer_path
cat frac_path | awk -F'[/ ]' '{print \$2\" \"\$4\" \"\$6}' > denom_path

lines=\$(wc -l denom_path | awk '{print \$1}')

sed -i \"1 i\\\\\$lines\" denom_path

cat denom_path | ./3frac2num > common_path
sed -i '1d' denom_path
paste denom_path common_path > denom_common
paste numer_path denom_common > num_den_com
rm frac_path numer_path denom_path common_path denom_common red_path_all red_path

cat num_den_com | awk '{printf(\"%15d%5d%5d%5d%5.1f\n\",\$1*\$7/\$4,\$2*\$7/\$5,\$3*\$7/\$6,\$7,2.0)}' > \$PRIM_PATH\".f2b\"
printf \"END\" >> \${PRIM_PATH}.f2b
mv \$PRIM_PATH \${PRIM_PATH}_backup
mv \${PRIM_PATH}.f2b \$PRIM_PATH

rm num_den_com

echo \"############################################################
#####               KPR2KSC version 0.0.1              #####
#####                                                  #####
##### Primitive cell klist_band to SUPERCELL converter #####
#####                                                  #####
#####    Not guaranteed that will work all the time    #####
##### Brought to you by Maciej P. Polak copyright 2016 #####
############################################################\"" > kpr2ksc/kpr2ksc

if [ $(which gcc) ]; then
	gcc -lm -o kpr2ksc/3dec2frac kpr2ksc/3dec2frac.c
	gcc -lm -o kpr2ksc/3frac2num kpr2ksc/3frac2num.c
	chmod +x kpr2ksc/kpr2ksc
	rm kpr2ksc/*.c
elif [ $(which icc) ]; then
	icc -o kpr2ksc/3dec2frac kpr2ksc/3dec2frac.c
	icc -o kpr2ksc/3frac2num kpr2ksc/3frac2num.c
	chmod +x kpr2ksc/kpr2ksc
	rm kpr2ksc/*.c
else
	echo "I cant find a C compiler, compile the two *.c files yourself"
	rm -r kpr2ksc
fi
