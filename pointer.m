main() 
{
	int l,m;
    int* p;
	l=1;
	m=2;
	print(l,"\n",m,"\n");
	p=&m; 
	*p=l;
	print(m,"\n");
}