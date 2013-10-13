%{
#include "tinc.hh"
typedef yy::Parser::token token;

#include <sstream>
#include <cstring>
using namespace std;

#define YY_DECL \
    yy::Parser::token_type yylex(yy::Parser::semantic_type *yylval)

#define yyterminate() return token::END
%}
%option noyywrap yylineno nounput
%%
"("                         { return token::LEFT_PAR; }
")"                         { return token::RIGHT_PAR; }
"{"                         { return token::LEFT_BRACE; }
"}"                         { return token::RIGHT_BRACE; }
";"                         { return token::SEMICOLON; }
"int"                       { return token::TYPE_INT; }
"if"                        { return token::IF; }
"else"                      { return token::ELSE; }
"while"                     { return token::WHILE; }
"return"                    { return token::RETURN; }
"||"                        { return token::OP_LOGICAL_OR; }
"&&"                        { return token::OP_LOGICAL_AND; }
"=="                        { return token::OP_EQUAL; }
"!="                        { return token::OP_NOT_EQUAL; }
"<"                         { return token::OP_LT; }
">"                         { return token::OP_GT; }
"<="                        { return token::OP_LTE; }
">="                        { return token::OP_GTE; }
"+"                         { return token::OP_PLUS; }
"-"                         { return token::OP_MINUS; }
"*"                         { return token::OP_TIMES; }
"/"                         { return token::OP_DIVIDE; }
"="                         { return token::OP_ASSIGN; }
","                         { return token::COMMA; }

[0-9][0-9]*                 {
                                istringstream is(yytext);
                                int i;
                                is >> i;

                                yylval->int_value = i;

                                return token::INTEGER;
                            }

[A-Za-z][A-Za-z_0-9]*       { 
                                yylval->str_value = strdup(yytext);
                                return token::IDENTIFIER;
                            }

[ \t\n]                     ;
.                           { cout << "Error: invalid character" << endl; }
%%