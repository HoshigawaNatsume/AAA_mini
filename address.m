main() 
{
	int a,b,x;
	a=1;
	b=2;
	print("a= ",a,"\n");
    print("b= ",b,"\n");
	func(a,b);
	print("a= ",a,"\n");
    print("b= ",b,"\n");
    x=func1(a,b);
    print("a= ",a,"\n");
    print("b= ",b,"\n");
    print("x= ",x,"\n");
}
func(&c,&d)
{
	c=20;
    d=10;
}
func1(e,f)
{
    e=100;
    f=200;
    return 99;
}