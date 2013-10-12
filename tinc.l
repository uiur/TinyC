%option noyywrap
%option yylineno
%{
#include "tinc.tab.h"
%}
%%
"("|")"|"{"|"}"|";"         { return *yytext; }
"int"                       { return TYPE_INT; }
"if"                        { return IF; }
"else"                      { return ELSE; }
"while"                     { return WHILE; }
"return"                    { return RETURN; }
"||"                        { return OP_LOGICAL_OR; }
"&&"                        { return OP_LOGICAL_AND; }
"=="                        { return OP_EQUAL; }
"!="                        { return OP_NOT_EQUAL; }
"<"                         { return OP_LT; }
">"                         { return OP_GT; }
"<="                        { return OP_LTE; }
">="                        { return OP_GTE; }
"+"                         { return OP_PLUS; }
"-"                         { return OP_MINUS; }
"*"                         { return OP_TIMES; }
"/"                         { return OP_DIVIDE; }
"="                         { return *yytext; }
","                         { return *yytext; }

[1-9][0-9]*                 { return INTEGER;  }
[A-Za-z][A-Za-z_0-9]*       { return IDENTIFIER; }

[ \t\n]                     ;
.                           yyerror("Error: invalid character");
%%