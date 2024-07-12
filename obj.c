#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "tac.h"
#include "obj.h"

/* global var */
int tos; // top of static 
int tof; // top of frame
int oof; // offset of formal
int oon; // offset of next frame
int count_str = 0; //计数 字符串
struct rdesc rdesc[R_NUM];//寄存器

int para_count = 0;//记录参数个数
int local_count = 0;//记录函数内的局部变量个数
int LDR_count = 0;//记录调用函数前 已有的寄存器，存入栈
int ret_end = 0;//记录是否已调用函数结束  1：已调用 0：未调用
int para_formal_count = 0;//记录形参个数
TAC * para_tac_temp = NULL;//临时记录形参
int ret_num_flag = 0;//有无返回值标记
int char_flag = 0;//字符标记，输出 %c
int address_actual = 0;// 1:正在操作的实参是地址

int stack_size = 0; // 栈空间大小

int print_address = 0;

//清除寄存器 r 关联的符号
void clear_desc(int r)
{
	rdesc[r].var=NULL;
}    
//符号n 与  r 寄存器 关联，即寄存器r 存n
void insert_desc(int r, SYM *n, int mod)
{
	/* Search through each register in turn looking for "n". There should be at most one of these. */
	int or; /* Old descriptor */
	for(or=R_GEN; or < R_NUM; or++)
	{
		if(rdesc[or].var==n)
		{
			/* Found it, clear it and break out of the loop. */
			clear_desc(or);
			break;
		}
	}

	/* Insert "n" in the new descriptor */

	rdesc[r].var=n;
	rdesc[r].modified=mod;
}     
//改写已有寄存器
void spill_one(int r)
{
	if((rdesc[r].var !=NULL) && rdesc[r].modified)
	{
		if(rdesc[r].var->store==1) /* local var */
		{
			printf("	str x%u,[sp, #%d]\n",r,rdesc[r].var->offset);
			local_count++; //局部变量个数+1
		}
		else /* global var */{}   
		rdesc[r].modified=UNMODIFIED;
	}
}
//改写所有寄存器
void spill_all(void)
{
	int r;
	for(r=R_GEN; r < R_NUM; r++) spill_one(r);
} 

//清除所有寄存器
void flush_all(void)
{
	int r;

	spill_all();

	for(r=R_GEN; r < R_NUM; r++) clear_desc(r);

	clear_desc(R_TP); /* Clear result register */
}
// 将符号 n 与寄存器 r 关联
void load_reg(int r, SYM *n) 
{
	int s;
	/* Look for a register */
    //在寄存器中寻找 符号n 关联的寄存器
	for(s=0; s < R_NUM; s++)  
	{
		if(rdesc[s].var==n)
		{
			{
				printf("	mov x%u,x%u\n", r, s);
            	//符号n 与r 寄存器关联
				insert_desc(r, n, rdesc[s].modified);
			}            
			return;
		}
	}
	/* Not in a reg. Load appropriately */
    //如果符号n 还没有与寄存器关联，即新符号（变量）
	switch(n->type)
	{
        //常数
		case SYM_INT:
		printf("	mov x%u,#%u\n", r, n->value);
		break;
        case SYM_CHAR:
		printf("	mov x%u,#%u\n", r, n->value);
		break;
		case SYM_VAR:
		if(n->store==1) /* local var */
		{
			if(n->offset >= 0)
            {
				if(ret_num_flag == 1)//是函数返回值
				{
					printf("	str x0, [sp, #%d]\n",n->offset);
					printf("	ldr x%u, [sp, #%d]\n",r,n->offset);
					ret_num_flag = 0;
				}
				else//其他局部变量
				{
					if(address_actual==1)//这个实参是地址
					{
						printf("	add x26, sp, #%d\n",n->offset);
					}
					else if(n->array_flag==0)//不是数组
					{
						
						printf("	ldr x%u, [sp, #%d]\n",r,n->offset);
					}
				}
            }
			else
            {}
		}
		else /* global var */
		{
            printf("	ldr x%u, =%s\n",r,n->name);
			printf("	ldr x%u, [x%u]\n",r,r);
		}
		break;
        //文本string
		case SYM_TEXT:
		//printf("	LOD R%u,L%u\n", r, n->label);
		break;
	}
	// if(n->array_address_flag == 1 && n->array_flag==1)//这个变量是数组首地址
	// 	{
	// 		printf("	ldr x26,[sp,#%d]\n", n->offset + n->array_offset*8);
	// 		printf("	str x%u,[x26]\n",r);
	// 		// printf("	*****************");
	// 	}
	insert_desc(r, n, UNMODIFIED);
}

/* Get the first reg as a destination reg. */
//获取第一个寄存器 op r1 r2 cont
int get_first_reg(SYM *c)
{
	int r; 
    //遍历寄存器，如果变量c 已经与寄存器关联
	for(r=R_GEN; r < R_NUM; r++) /* Already in a register */
	{
		if(rdesc[r].var==c)
		{
			spill_one(r);
			return r;
		}
	}
    //新变量，找一个空寄存器直接关联即可
	for(r=R_GEN; r < R_NUM; r++)
	{
		if(rdesc[r].var==NULL) /* Empty register */
		{
			load_reg(r, c);
			return r;
		}

	}
	//如果没有空寄存器，找没修改的寄存器
	for(r=R_GEN; r < R_NUM; r++)
	{
		if(!rdesc[r].modified) /* Unmodifed register */
		{
			clear_desc(r);
			load_reg(r, c);
			return r;
		}
	}
    //如果以上条件都没有，直接选第5个 
	spill_one(R_GEN); /* Modified register */
	clear_desc(R_GEN);
	load_reg(R_GEN, c);
	return R_GEN;
} 

/* Get the second reg as a source reg. Exclude the first reg. */
//排除第一个寄存器，获取第二个寄存器 op r1 r2 cont
int get_second_reg(SYM *b, int first_reg)             
{
	int r;
	for(r=R_GEN; r < R_NUM; r++)
	{
		if(rdesc[r].var==b) /* Already in register */
		return r;
	}

	for(r=R_GEN; r < R_NUM; r++)
	{
		if(rdesc[r].var==NULL) /* Empty register */
		{
			load_reg(r, b);
			return r;
		}
	}

	for(r=R_GEN; r < R_NUM; r++)
	{
		if(!rdesc[r].modified && (r != first_reg)) /* Unmodifed register */
		{
			clear_desc(r);
			load_reg(r, b);
			return r;
		}
	}

	for(r=R_GEN; r < R_NUM; r++)
	{
		if(r != first_reg) /* Modified register */
		{
			spill_one(r);
			clear_desc(r);
			load_reg(r, b);
			return r;
		}
	}
}
//二元操作
void asm_bin(char *op, SYM *a, SYM *b, SYM *c)
{
	int reg1=get_first_reg(b); /* Result register */
	int reg2=get_second_reg(c, reg1); /* One more register */

	//printf("	%s R%u,R%u\n", op, reg1, reg2);
    printf("	%s x%u,x%u,x%u\n", op, reg1, reg1, reg2); //改这个

	/* Delete c from the descriptors and insert a */
	clear_desc(reg1);
	insert_desc(reg1, a, MODIFIED);
}   
//比较操作
void asm_cmp(int op, SYM *a, SYM *b, SYM *c)
{
	int reg1=get_first_reg(b); /* Result register */
	int reg2=get_second_reg(c, reg1); /* One more register */

	//printf("	SUB R%u,R%u\n", reg1, reg2);
    //printf("	sub x%u,x%u,x%u\n", reg1,reg1, reg2);
	//printf("	TST R%u\n", reg1);
    printf("    cmp x%u,x%u\n",reg1,reg2);

	switch(op)
	{		
		case TAC_EQ:
        printf("	cset x28, eq\n");
		break;
		
		case TAC_NE:
		printf("	cset x28, ne\n");
		break;
		
		case TAC_LT:
		printf("	cset x28, lt\n");
		break;
		
		case TAC_LE:
		printf("	cset x28, le\n");
		break;
		
		case TAC_GT:
		printf("	cset x28, gt\n");
		break;
		
		case TAC_GE:
		printf("	cset x28, ge\n");
		break;
	}

	/* Delete c from the descriptors and insert a */
	clear_desc(reg1);
	insert_desc(reg1, a, MODIFIED);
}   
//汇编 复制 赋值
void asm_copy(SYM *a, SYM *b, SYM *c)
{
	
	int reg1=get_first_reg(b); /* Load b into a register */
	if (a->array_flag==1){
		if (a->array_address_flag==1 && a->formal_flag==1){
			printf("	ldr x26, [sp, #%d]\n", a->offset + c->array_offset*8);
			printf("	str x%u, [x26]\n", reg1);

		}
		else{
			//printf("%s,,%d,,%d",a->name,a->formal_flag,a->array_address_flag);
			printf("	str x%u, [sp,#%d]", reg1, a->offset + c->array_offset*8);
		}
		
	}
	else if(a->pointer_flag==1 && b->address_flag==0)
	{

		//printf("	ldr x26, [sp, #%d]\n",b->offset);
		printf("	ldr x26,[sp,#%d]\n",a->offset);
		printf("	str x%u, [x26]\n",reg1);
	}
	else if(a->pointer_flag==1 && b->address_flag==1)
	{

		printf("	add x26, sp, #%d\n",b->offset);
		//printf("	mov x%d,x26\n",reg1);
		printf("	str x26,[sp,#%d]\n",a->offset);
	}
	else{
		insert_desc(reg1, a, MODIFIED); /* Indicate a is there */
		if(a->store == 0)//全局变量
		{
			printf("	ldr x7, =%s\n",a->name);
			printf("	str x%u, [x7]\n",reg1);
		}
		else if(a->address_flag == 1)//这个变量是地址
		{
			printf("	str x%u, [x%u]",reg1,reg1-8);
		}
		else if(a->array_address_flag == 1 && a->array_flag==1)//这个变量是数组首地址
		{
			printf("	ldr x26,[sp,#%d]", a->offset + c->array_offset*8);
			printf("	str x%u,[x26]",reg1);
			// printf("	*****************");
		}

	}

}    
//
void asm_cond(char *op, SYM *a,  char *l)
{
	spill_all();

	// if(a !=NULL)
	// {
	// 	int r;

	// 	for(r=R_GEN; r < R_NUM; r++) /* Is it in reg? */
	// 	{
	// 		if(rdesc[r].var==a) break;
	// 	}

	// 	if(r < R_NUM) printf("	TST R%u\n", r);
	// 	else printf("	TST R%u\n", get_first_reg(a)); /* Load into new register */
	// }
	printf("	mov x27, #0\n");
	printf("	cmp x28, x27\n");
	printf("	%s %s\n", op, l); 
} 
//返回
void asm_return(SYM *a)
{
	if(a !=NULL)					/* return value */
	{
		spill_one(R_TP);
		load_reg(R_TP, a);
        //spill_one(R_w0);
        //load_one(R_w0,a);

	}
	else
	{
		printf("	mov x0,#0\n");
	}
	// printf("	LOD R3,(R2+4)\n");	/* return address */
	// printf("	LOD R2,(R2)\n");	/* restore bp */
	// printf("	JMP R3\n");		/* return */
	
	printf("	add sp,sp,#%d\n", (stack_size+1)/2 * 16);
	printf("	ldp x29, x30, [sp], #16\n");
	
	printf("	ret\n");
}   

void asm_head()
{
	//char head[]=
	//"	# head\n"
	//"	LOD R2,STACK\n"
	//"	STO (R2),0\n"
	//"	LOD R4,EXIT\n"
	//"	STO (R2+4),R4";
    char head1[]=
    "   .arch armv8-a";
    puts(head1);
    char head2[]=
    "   .text\n"
    "   .align	2\n"
    "   .global	main\n"
    "   .type	main, %function";
	puts(head2);
}
//print 库
void asm_lib()
{
	
	char lib[]=
	"\nPRINTN:\n"
	;
	puts(lib);
}

void asm_str(SYM *s)
{
	char *t=s->name; /* The text */
	int i;

	//printf("L%u:\n", s->label); /* Label for the string */
	//printf("	DBS "); /* Label for the string */
    printf("    %s:\n",t);

	for(i=1; t[i + 1] !=0; i++)
	{
		if(t[i]=='\\')
		{
			switch(t[++i])
			{
				case 'n':
				printf("%u,", '\n');
				break;

				case '\"':
				printf("%u,", '\"');
				break;
			}
		}
		else printf("%u,", t[i]);
	}

	printf("0\n"); /* End of string */
}

void asm_static(void)
{
	int i;

	SYM *sl;

	for(sl=sym_tab_global; sl !=NULL; sl=sl->next)
	{
		if(sl->type==SYM_TEXT) asm_str(sl);
	}

	printf("STATIC:\n");
	printf("	DBN 0,%u\n", tos);				
	printf("STACK:\n");
}

void asm_code(TAC *c)
{
	int r;

	switch(c->op)
	{
		case TAC_UNDEF:
		error("cannot translate TAC_UNDEF");
		return;

		case TAC_ADD:
		asm_bin("add", c->a, c->b, c->c);
		return;

		case TAC_SUB:
		asm_bin("sub", c->a, c->b, c->c);
		return;

		case TAC_MUL:
		asm_bin("mul", c->a, c->b, c->c);
		return;

		case TAC_DIV:
		asm_bin("udiv", c->a, c->b, c->c);
		return;

		case TAC_NEG:
		asm_bin("sub", c->a, mk_const(0), c->b);
		return;

		case TAC_EQ:
		case TAC_NE:
		case TAC_LT:
		case TAC_LE:
		case TAC_GT:
		case TAC_GE:
		asm_cmp(c->op, c->a, c->b, c->c);
		return;

		case TAC_COPY:
		asm_copy(c->a, c->b, c->c);

		return;

		case TAC_GOTO:
		asm_cond("b", NULL, c->a->name);
		return;

		case TAC_IFZ:
		//asm_cond("cbz", c->b, c->a->name);
		asm_cond("b.eq", c->b, c->a->name);
		return;

		case TAC_LABEL:
		flush_all();
		if(strcmp(c->a->name,"main")==0)
		{
			printf("	.text\n");
			printf("	.global %s\n", c->a->name);
			
		}
		
		printf("%s:\n", c->a->name);
		return;

		case TAC_ACTUAL://实参
		if(c->a != NULL && c->a->char_flag == 1)//当前操作的是char类型
		{
			char_flag = 1;
		}
		else
		{
			char_flag = 0;
		}
		
		TAC* temptac;
		temptac = c;
		for(;temptac!=NULL && temptac->op != TAC_CALL;temptac=temptac->next);//找到传入实参的函数

		if(temptac== NULL || strcmp((char*)temptac->b, "PRINTN")==0 || strcmp((char*)temptac->b, "PRINTS")==0){}
		else//自定义函数
		{
			TAC* temptac2 = temptac;
			for(;;temptac2=temptac2->next)//找到函数开始标签
			{
				if(temptac2!=NULL && temptac2->op==TAC_LABEL && strcmp(temptac2->a->name, (char*)temptac->b)==0)
					break;
			}
			TAC* temptac3 = temptac2;
			for(;temptac3->op!=TAC_FORMAL;temptac3=temptac3->next);//函数定义时的形参
			if(temptac3!=NULL && temptac3->a!=NULL && temptac3->a->address_flag==1)//形参类型是地址
			{
				printf("	# address\n");
				address_actual = 1;//标记实参是地址
			}
		}
		if(c->a != NULL && c->a->type == SYM_TEXT)//字符串
		{
			printf("	ldr x0, =str%d\n",c->a->count);
			return;
		}
		else
		{
			
			TAC*temp = c;
			if(para_count == 0)//没有计数参数，则开始计数
			{
				while(temp != NULL && temp->op == TAC_ACTUAL)//计数实参
				{
					para_count++;
					temp = temp->next;
				}
			}
			r=get_first_reg(c->a);
			if(address_actual==1)//这个实参是地址
			{
				printf("	mov x%u,x26 \n",para_count-1,r);
			}
			else if(c->a->array_flag==1)//这是数组
			{		
				if(c->a->array_address_flag == 1){
					printf("	add x26,sp,#%d\n",c->a->offset+8*c->array_offset);
					printf("	mov x%u,x26 \n",para_count-1);
					print_address = 1;
				}	
				else{
					printf("	ldr x%u,[sp,#%d]\n",r,c->a->offset+8*c->array_offset);
					printf("	mov x%u,x%u \n",para_count-1,r);
				}
				
			}	
			else
			{
				if(para_count-1!=r)
					printf("	ldr x%u,[sp,#%d] \n",r,c->a->offset);
					printf("	mov x%u,x%u \n",para_count-1,r);
			}
			
			para_count--;
			oon += 8;

			return;
		}
		
		//oon += 4;
		return;

		case TAC_CALL:
		address_actual = 0;//重置实参是地址的标记
		LDR_count = 0;
		flush_all();
		if (strcmp((char*)c->b, "PRINTN")==0)//变量
		{
			
			if (print_address==1){
				print_address = 0;
				printf("	ldr x1,[x0]\n");
			}
			else{
				printf("	mov x1, x0\n");
			}

			if(char_flag)//是char类型
			{
				printf("	ldr x0, =str\n");
			}
			else
			{
				printf("	ldr x0, =str0\n");
			}
			
			//printf("	mov x1, x%u",get_first_reg(c->a));
			
			printf("	bl printf\n");
			para_count = 0;
		}
		else if (strcmp((char*)c->b, "PRINTS")==0)//纯文本
		{
			printf("	bl printf\n");
			para_count = 0;
		}
		else if(c->a == NULL)//无返回值
		{
			printf("	bl %s\n",(char *)c->b);
			para_count = 0;
		}
		else//有返回值
		{
			printf("	bl %s\n",(char *)c->b);
			ret_num_flag = 1;//有返回值标记
			para_count = 0;
		}
		oon=0;
		
		return;

		case TAC_BEGINFUNC:
		/* We reset the top of stack, since it is currently empty apart from the link information. */
		scope_local=1;
		tof=LOCAL_OFF;
		oof=FORMAL_OFF;
		oon=0;
		stack_size = 0;
		for(TAC *cur=c; cur->op!=TAC_ENDFUNC; cur=cur->next)
		{
			if(cur->op==TAC_VAR || cur->op==TAC_FORMAL)
			{
				if (cur->a->array_flag==1)
				{
					stack_size += cur->a->array_size;
				}
				else
				{
					stack_size ++;
				}
			}
		}
		printf("	stp x29, x30, [sp, #-16]!\n");
		printf("	sub sp,sp,#%d\n", (stack_size+1)/2 * 16);
		return;

		case TAC_FORMAL:	//形参
		if(para_tac_temp == NULL) para_tac_temp = c;
		c->a->store=1; /* parameter is special local var */
		c->a->offset=oof;
		oof += 8;
		printf("	str x%u,[sp,#%d]",para_formal_count,c->a->offset);
		
		para_formal_count++;
		return;

		case TAC_VAR: //变量
		if(scope_local)
		{
			c->a->store=1; /* local var */
			c->a->offset=tof;
			//tof += 4;
			if (c->a->array_flag==1){
				tof += 8*c->a->array_size;
			}
			else{
				tof += 8;
			}
			// tof += 8;

		}
		else
		{
			// 全局变量， 没有实现数组
			c->a->store=0; /* global var */
			c->a->offset=tos;
			//tos +=4;
			tos += 8;
			printf("%s:\n",c->a->name);
			printf("	.word 0\n");
		}
		return;

		case TAC_RETURN:
		if(ret_end == 0)
		{
			asm_return(c->a);
			ret_end = 1;
		}
		
		return;

		case TAC_ENDFUNC:
		if(ret_end == 0)
		{
			asm_return(NULL);
		}
		ret_end = 0;
		para_formal_count = 0;
		scope_local=0;
		return;

		default:
		/* Don't know what this one is */
		error("unknown TAC opcode to translate");
		return;
	}
}

void tac_obj()
{

	tof=LOCAL_OFF; /* TOS allows space for link info */
	oof=FORMAL_OFF;
	oon=0;

	int r;
	for(r=0; r < R_NUM; r++) 
		rdesc[r].var=NULL;
	insert_desc(0, mk_const(0), UNMODIFIED); /* R0 holds 0 */

	//asm_head();

    //三地址码 -> 汇编
	TAC * cur;
	printf("	.data\n");
	printf("str0:\n");
	printf("	.string \"%%d\"\n");
	printf("str:\n");
	printf("	.string \"'%%c'\"\n");
	int my_count = 0;
	for(cur=tac_first; cur!=NULL; cur=cur->next)
	{
		if (cur->a != NULL)
		{
			if( cur->a->type == SYM_TEXT)
			{
				if(cur->a->count > my_count)
				{
					printf("str%d:\n",cur->a->count);
					printf("	.string %s\n",cur->a->name);
					my_count++;
				}
				
			}
			
			// else if(cur->a->type == SYM_VAR && cur->a->store == 0)//全局变量声明
			// {
			// 	char sa[12];
			// 	printf("%s:\n",to_str(cur->a, sa));
			// 	printf("	.word 0\n");
			// }
		}

	}

	//printf("	.text\n");
	//printf(".global main\n");
	for(cur=tac_first; cur!=NULL; cur=cur->next)
	{
		
		printf("\n	# ");
		tac_print(cur);
		printf("\n");
		asm_code(cur);
	}
	//asm_lib();
	//asm_static();
} 

