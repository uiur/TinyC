%skeleton "lalr1.cc"
%{
#include <iostream>
#include <sstream>
#include <string>
#include <cstdio>
#include "expression.h"
using namespace std;

%}
%error_verbose

%define "parser_class_name" "Parser"

%union {
    int int_value;
    char *str_value;
    Node *node;
}

%token <int_value> INTEGER 
%token <str_value> IDENTIFIER
%token LEFT_PAR RIGHT_PAR LEFT_BRACE RIGHT_BRACE SEMICOLON
%token OP_ASSIGN COMMA
%token TYPE_INT
%token IF ELSE RETURN WHILE
%token <int_value> OP_LT OP_GT OP_LTE OP_GTE
%token <int_value> OP_LOGICAL_OR OP_LOGICAL_AND
%token <int_value> OP_EQUAL OP_NOT_EQUAL
%token <int_value> OP_PLUS OP_MINUS
%token <int_value> OP_TIMES OP_DIVIDE
%token END 0


%left OP_PLUS OP_MINUS
%left OP_TIMES OP_DIVIDE

%type <node> add_expr mult_expr primary_expr relational_expr constant identifier expression equality_expr unary_expr assign_expr logical_or_expr logical_and_expr program main declaration external_declaration declarator_list declarator function_definition parameter_type_list  parameter_declaration statement compound_statement declaration_list statement_list if_statement while_statement

%{
#include "tinc.hh"
#define YY_DECL \
    yy::Parser::token_type yylex(yy::Parser::semantic_type *yylval)

YY_DECL;
%}

%%
main:
    program {
        $1->print(cout);
        $$ = $1;
    }
    ;
program:
    external_declaration
    | program external_declaration {
        $$ = new NodeList($1, $2);
    }
    ;
external_declaration:
    declaration
    | function_definition
    ;
declaration:
    TYPE_INT declarator_list SEMICOLON {
        $$ = new NodeDefineVariable($2);
    }
    ;
declarator_list:
    declarator
    | declarator_list COMMA declarator {
        $$ = new NodeList($1, $3);
    }
    ;
declarator:
    identifier
    ;

function_definition:
    TYPE_INT declarator LEFT_PAR RIGHT_PAR compound_statement {
        $$ = new NodeFunction($2, NULL, $5);
    }
    | TYPE_INT declarator LEFT_PAR parameter_type_list RIGHT_PAR compound_statement {
        $$ = new NodeFunction($2, $4, $6);
    }
    ;
parameter_type_list:
    parameter_declaration
    | parameter_type_list COMMA parameter_declaration {
        $$ = new NodeList($1, $3);
    }
    ;
parameter_declaration:
    TYPE_INT declarator {
        $$ = new NodeDefineVariable($2);
    }
    ;

statement:
    SEMICOLON
    | expression SEMICOLON {
        $$ = $1;
    }
    | compound_statement
    | if_statement
    | while_statement
    | RETURN expression SEMICOLON {
        $$ = new NodeReturn($2);
    }
    ;

if_statement:
    IF LEFT_PAR expression RIGHT_PAR statement {
        $$ = new NodeIfBlock($3, $5, NULL);
    }
    | IF LEFT_PAR expression RIGHT_PAR statement ELSE statement {
        $$ = new NodeIfBlock($3, $5, $7);
    }
    ;

while_statement:
    WHILE LEFT_PAR expression RIGHT_PAR statement {
        $$ = new NodeWhileBlock($3, $5);
    }
    ;


compound_statement:
    LEFT_BRACE RIGHT_BRACE {
        $$ = NULL;
    }
    | LEFT_BRACE statement_list RIGHT_BRACE {
        $$ = $2;
    }
    | LEFT_BRACE declaration_list RIGHT_BRACE {
        $$ = $2;
    }
    | LEFT_BRACE declaration_list statement_list RIGHT_BRACE {
        $$ = new NodeList($2, $3);
    }
    ;
declaration_list:
    declaration
    | declaration_list declaration {
        $$ = new NodeList($1, $2);
    }
    ;
statement_list:
    statement
    | statement_list statement {
        $$ = new NodeList($1, $2);
    }
    ;

expression:
    assign_expr
    | expression COMMA assign_expr {
        $$ = new NodeList($1, $3);
    }
    ;
assign_expr:
    logical_or_expr
    | identifier OP_ASSIGN assign_expr {
        $$ = new NodeAssign($1, $3);
    }
    ;
logical_or_expr:
    logical_and_expr
    | logical_or_expr OP_LOGICAL_OR logical_and_expr {
        $$ = new NodeRelation($2, $1, $3);
    }
    ;
logical_and_expr:
    equality_expr
    | logical_and_expr OP_LOGICAL_AND equality_expr {
        $$ = new NodeRelation($2, $1, $3);
    }
    ;

equality_expr:
    relational_expr
    | equality_expr OP_EQUAL relational_expr {
        $$ = new NodeRelation($2, $1, $3);
    }
    | equality_expr OP_NOT_EQUAL relational_expr {
        $$ = new NodeRelation($2, $1, $3);
    }
    ;

relational_expr:
    add_expr
    | relational_expr OP_LT add_expr {
        $$ = new NodeRelation($2, $1, $3);
    }
    | relational_expr OP_GT add_expr {
        $$ = new NodeRelation($2, $1, $3);
    }
    | relational_expr OP_LTE add_expr {
        $$ = new NodeRelation($2, $1, $3);
    }
    | relational_expr OP_GTE add_expr {
        $$ = new NodeRelation($2, $1, $3);
    }
    ;

add_expr:
    mult_expr
    | add_expr OP_PLUS mult_expr {
        $$ = new NodeArithmeticOperation($2, $1, $3);
    }
    | add_expr OP_MINUS mult_expr {
        $$ = new NodeArithmeticOperation($2, $1, $3);
    }
    ;
mult_expr:
    unary_expr
    | mult_expr OP_TIMES unary_expr {
        $$ = new NodeArithmeticOperation($2, $1, $3);
    }
    | mult_expr OP_DIVIDE unary_expr {
        $$ = new NodeArithmeticOperation($2, $1, $3);
    }
    ;

unary_expr:
    postfix_expr
    | OP_MINUS unary_expr {
        $$ = new NodeMonoArithmeticOperation($1, $2);
    }
    ;

postfix_expr:
    primary_expr
    ;

primary_expr:
    identifier
    | constant
    | LEFT_PAR expression RIGHT_PAR {
        $$ = $2;
    }
    ;

constant:
    INTEGER {
        $$ = new NodeInteger($1);
    }
    ;

identifier:
    IDENTIFIER {
        $$ = new NodeIdent(string($1));
    }
    ;

%%

extern int yylineno;

void yy::Parser::error(const location_type& loc, const string& msg) {
    std::cerr << loc << ':' << msg << endl;
}

int main(void) {
    yy::Parser p;

    p.parse();    
    return 0;
}