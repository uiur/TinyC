%option noyywrap
%option yylineno
%{
#include "tinc.tab.h"
%}
%%
"("|")"|"{"|"}"|";"         { return *yytext; }
"int"                       { return *yytext; }
"if"|"while"                { return *yytext; }
"return"                    { return *yytext; }
"||"|"&&"                   { return *yytext; }
"=="|"!="
"<"|">"|"<="|">="
"+"|"-"|"*"|"/"
","

[1-9][0-9]*                 { return INTEGER;  }
[A-Za-z][A-Za-z_0-9]*       { return IDENTIFIER; }

[ \t\n]                     ;
.                           yyerror('Error: invalid character');
%%