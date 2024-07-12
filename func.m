int i,j,k;

main() 
{
	int l,m,n;
	int *p;
	*p=n;
	p=&m; 
	l=*p;
	[sp,#8]
	l=1;
	m=2;
	n=3;
	print(l,m,n,"\n");
	n=func(l,m,n);
	print(i,j,k,"\n");
	print(n,"\n");
}
func(o,p,q)
{
	print(o,p,q,"\n");
	i=o;
	j=p;
	k=q;
	print(i,j,k,"\n");
	return 999;
}
