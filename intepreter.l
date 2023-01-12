%{
#include "projectt.tab.h"
%}
separator   [\t\n\r ]
letter      [a-z]
digit       [0-9]

number	    0|[1-9]{digit}*|-[1-9]{digit}*
ID	        {letter}({letter}|{digit}|-)*

%%

"print-num" {return print_num ;}
"print-bool" {return print_bool ;}
"+"|"-"|"*"|"/"|">"|"<"|"="|"("|")" {return yytext[0] ;}
"mod" {return MOD ;}
"and" {return AND ;}
"or" {return OR ;}
"not" {return NOT ;}
"if" {return IF ;}
"define" {
              yylval.data.name=yytext[0];
              return define ;
         }
{number} {
              yylval.data.ival=atoi(yytext);
              yylval.data.type='n';
              return number ;
         }
{ID} {        
                yylval.data.name=yytext[0];
                yylval.data.type='n';
                 return ID ;
    }
"#t" {       
                yylval.data.name=yytext[0];
                 yylval.data.ival=1;
                 yylval.data.type='b';
                 return bool_val ;
    }
"#f" {      
                yylval.data.name=yytext[0];
                yylval.data.type='b';
                yylval.data.ival=0;
                return bool_val ;
    }
{separator}	{ }
. {return yytext[0] ;}
%%