%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#define INDENT (4)
int line = 1;
int column = 4;
int paren = 0;
%}

quote  '
ditto  "
back  \\
alpha [A-Za-z]
digit  [0-9]
exp [Ee][\+\-]?{digit}+
hex ({digit}|[a-fA-F])
ch [^ \n'"\]

%%
auto|break|case|char|const|continue|defualt|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while					                         {write_keywords();}
#include[ |\t]*<[^\n>]+>   				      	 {write_directive();}
#define[ |\t]+[^\n]+						 {write_directive();}		
"{"								 {write_begin();}
"}"								 {write_end();}
"("								 {write_open();}
")"								 {write_close();}
(\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/)|(\/\/.*)		 {write_comment();}
">>="|"<<="|"+="|"-="|"*="|"/="|"&="|"^="|"|=" |">>"|"<<"|"\++"|"--"|"->"|"&&"|"||"|"<="|">="|"=="|"!="|","|":"|"="|"<:"|":>"|"."|"&"|"!"|"~"|"-"|"\+"|"*"|"/"|"%"|"<"|">"|"^"|"|"|"?"|"%="|                                    {write_op();}
0([0-7]+)	                                                 {write_oct();}
0(x|X){hex}+						         {write_hex();}
(\-|{digit}){digit}{digit}*				         {write_int();}
{digit}*\.{digit}*{exp}?				         {write_fp();}
{alpha}({alpha}|{digit})*				         {write_id();}
\"(\\.|[^\\"])*\"					         {write_string();}
\'(\\.|[^\\"])\'					       	 {write_char();}
;								 {write_sep();}
[\t]
\n                                                             	 {indent();}
%%

indent()
{
printf("\n%-*d",column,line++);

}

write_html_char(int c)
{

switch (c)
{ 
case '<': printf("&lt;"); break;
case '>': printf("&gt;"); break;
case '"': printf("&quot;"); break;
case '&': printf("&amp;"); break;
default:putchar(c);
}

}


write_html() { 
char *s = yytext;
while (*s)
write_html_char(*s++);

}
write_op()
{
printf("<font color='#000080'>");
write_html();
printf("</font>");
}

write_id()
{
printf("<font color='#000080'>");
printf("%s",yytext);
printf("</font>");
}
write_fp()
{
printf("<font color='#000080'><b>");
printf("%s",yytext);
printf("</b></font>");
}

write_keywords()
{

printf("<font color='#000080'><b>");
printf("%s",yytext);
printf("</b></font>");


}

write_comment()
{ char c, c1;
printf("<font color='#00FF00'>");
indent();
printf("%s",yytext);
printf("</font>");
}



write_directive()
{
char  c,c1;
printf("<font color='#FF00FF'> ");
write_html();
printf("</font>");
}

write_oct()
{
printf("<font color='#00FFFF'><i> ");
printf("%s",yytext);
printf("</i></font>");
}

write_hex()
{
printf("<font color='#00FFFF'><i> ");
printf("%s",yytext);
printf("</i></font>");
}

write_int()
{
printf("<font color='#00FFFF'><i> ");
printf("%s",yytext);
printf("</i></font>");
}

write_char()
{
printf("<font color='#00FFFF'><u> ");
printf("%s",yytext);
printf("</u></font>");

}

write_string()
{
printf("<font color='#FF0000'> ");
printf("%s",yytext);
printf("</font>");
}


write_begin()
{ 
indent();
write_html();
column += INDENT;
indent();
}

write_end()
{ column -= INDENT;
indent();
write_html();
indent();
}

write_open()
{
write_html();
putchar(' ');
paren++;
}

write_close()
{
write_html();
putchar(' ');
paren--;
}

write_sep()
{ 
write_html();
if (!paren)
indent();
else
putchar(' ');
}

int main()
{
printf("<html><pre>\n");
printf("<body>\n");
indent();
yylex();
printf("</body>\n");
printf("\n</pre></html>\n");
return 0;
}
