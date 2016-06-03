#include <stdio.h>
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
	scanf("%d",&lines);
	for(i=1;i<=lines;i++)
	{
		scanf("%d %d %d", &a, &b, &c);
		if(a==0) a=1;
		if(b==0) b=1;
		if(c==0) c=1;
		d=a*b/euklid(a,b);
		printf("%d\n", c*d/euklid(c,d));
	}
	return 0;
}
