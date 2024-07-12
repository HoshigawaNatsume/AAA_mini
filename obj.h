/* register */
#define R_UNDEF -1
#define R_FLAG 0
/*
#define R_IP 1  //sp 
#define R_BP 2  //fp 
#define R_JP 3
#define R_TP 4  //w0 x0
*/
#define R_w0 0
#define R_TP 0
#define R_GEN 8  //原来 5
#define R_NUM 28 //原来 16
#define R_sp 31 //栈指针寄存器，用于存储局部变量和函数调用的返回地址
#define R_fp 29 //帧指针寄存器，用于指向当前栈帧的基地址
#define R_lr 30 //链接寄存器，用于保存函数调用时的返回地址

/* frame */
//define FORMAL_OFF -4 	/* first formal parameter */
#define FORMAL_OFF 0
#define OBP_OFF 0 		/* dynamic chain */
//#define RET_OFF 4 		// ret address 保存在 R_lr寄存器
#define RET_OFF 0
//#define LOCAL_OFF 8 		/* local var */
#define LOCAL_OFF 0

#define MODIFIED 1
#define UNMODIFIED 0

struct rdesc /* Reg descriptor */
{
	struct sym *var; /* Variable in reg */
	int modified; /* If needs spilling */
};

extern int tos; /* top of static */
extern int tof; /* top of frame */
extern int oof; /* offset of formal */
extern int oon; /* offset of next frame */
extern char *name;
extern SYM *sym_tab_global, *sym_tab_local;   //全局和局部符号表

void tac_obj();
char *to_str(SYM *s, char *str);

