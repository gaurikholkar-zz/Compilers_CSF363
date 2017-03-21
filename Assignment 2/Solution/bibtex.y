%{
#include <stdio.h>
int  yylex(void);
int sym[26];
%}

%union {
char * str;
int number;
};

%token  LBRACE
%token  RBRACE
%token  COMMA
%token <number> NUMBER
%token  EQUALS
%token  AT
%token QUOTE
%token <str>NAME
%token <str>STRING

%%

bibfile : entries    {printf("parsed\n");}
        ;
entries : entry nline entries 
	| entry
	| nline
	;

entry : AT NAME LBRACE key COMMA nline fields RBRACE  {printf("name %s\n",$2);}
	;

key: NAME     {printf("name %s\n",$1);} 
   | NUMBER   {printf("number %d\n",$1);}
   ;

fields : field COMMA nline fields  
       | field  nline
        ; 

nline :
	;

field : NAME EQUALS LBRACE value RBRACE   {printf("name %s\n",$1);}
	|NAME EQUALS QUOTE value QUOTE	  {printf("name %s\n",$1);}
      ;
value :names
    ;
names  : STRING	{printf("string %s\n",$1);}
	|NAME {printf("name %s\n",$1);}
	|NUMBER {printf("number %d\n",$1);}
	|opp COMMA names	
	;
opp :	STRING	{printf("string %s\n",$1);}
	|NAME {printf("name %s\n",$1);}
	|NUMBER {printf("number %d\n",$1);}
	;
%%

int yyerror(char *s) {
  
}


int main(void)
{
  yyparse();
  return 0;
}

