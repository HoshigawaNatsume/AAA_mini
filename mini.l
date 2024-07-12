%{
#include <stdlib.h>
#include "tac.h"
#include "y.tab.h"
%}

%option yylineno

%%

"int"  {  return INT;  }

"int*"  {  return POINTER;  }

"char"  {  return CHAR;  }

"char*"  {  return POINTER;  }

"print"  {  return PRINT;  }

"return"  {  return RETURN;  }

"continue"  {  return CONTINUE;  }

"if"  {  return IF;  }

"then"  {  return THEN;  }

"else"  {  return ELSE;  }

"fi"  {  return FI;  }

"while"  {  return WHILE;  }

"for"  { return FOR; }

"do"  {  return DO;  }

"done"  {  return DONE;  }

\*[A-Za-z]([A-Za-z]|[0-9])*  {  
	char tmp[20];
	int len = strlen(yytext);
	for(int i=0;i<len-1;++i)
	{
		tmp[i]=yytext[i+1];
	}
	yylval.string = strdup(tmp); 
	return IDENTIFIER;
}


[A-Za-z]([A-Za-z]|[0-9])*  {  
	yylval.string = strdup(yytext); 
	return IDENTIFIER;
}

[0-9]*	{
	yylval.string = strdup(yytext); 
	return INTEGER;
}

\"[^\"]*\"  {
	yylval.string = strdup(yytext); 
	return TEXT;
}

\'[A-Za-z]\'  {
    yylval.string = strdup(yytext); 
	return CHARACTER;
}



"=="  {  return EQ;  }

"!="  {  return NE;  }

"<="  {  return LE;  }

"<"  {  return LT;  }

">="  {  return GE;  }

">"  {  return GT;  }

[ \t\r\n]|#.*

. 	{	return *yytext; }

%%

int yywrap()
{
	return 1;
}

