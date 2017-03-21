%option noyywrap
%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>
%}
alpha [A-Za-z]
%%

\@	{return AT;}
\%~[\n]*\n {;}
[\ \r\t]+ {;}
~[\@\n\ \r\t]+	{;}
[0-9]+  {yylval.number = atoi(yytext); return NUMBER;}
[a-z0-9\!\$\&\*\+\-\.\/\:\;\<\>\?\[\]\^\_\'\|]+ {yylval.str = strdup(yytext); return NAME;}
\{      {return LBRACE;}
\}    	{return RBRACE;}
\=      {return EQUALS;}
\,      {return COMMA;}
\"	{return QUOTE;}
([a-zA-Z])* {yylval.str = strdup(yytext);return STRING;}

%%


