#include <stdio.h>
#include <math.h>
int main()
{

	float eps=0.0001;

	float inp, x, n, min_l, min_m, max_l, max_m, mid_l, mid_m;
	int num=1;
	while(scanf("%f", &x)!=EOF)
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
			if(x<eps) {printf("0/1 "); break;}
			else if(x>1-eps) {printf("1/1 "); break;}
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
				printf("%.0f/%.0f ", n*mid_m+mid_l, mid_m);
				break;
			}
		}
		if(num==3) 
		{
			printf("\n");
			num=0;
		}
		num=num+1;
	}
	return 0;
}
