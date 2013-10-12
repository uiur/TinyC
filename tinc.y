%{
#include <stdio.h>
%}
%error_verbose

%token INTEGER IDENTIFIER TYPE_INT
%token IF ELSE RETURN WHILE
%token OP_LT OP_GT OP_LTE OP_GTE
%token OP_LOGICAL_OR OP_LOGICAL_AND
%token OP_EQUAL OP_NOT_EQUAL
%token OP_PLUS OP_MINUS
%token OP_TIMES OP_DIVIDE

%left OP_PLUS OP_MINUS
%left OP_TIMES OP_DIVIDE
%%
program:
    external_declaration
    | program external_declaration
    ;
external_declaration:
    declaration
    | function_definition
    ;
declaration:
    TYPE_INT declarator_list ';'
    ;
declarator_list:
    declarator
    | declarator_list ',' declarator
    ;
declarator:
    IDENTIFIER
    ;

function_definition:
    TYPE_INT declarator '(' ')' compound_statement
    | TYPE_INT declarator '(' parameter_type_list ')' compound_statement
    ;
parameter_type_list:
    parameter_declaration
    | parameter_type_list ',' parameter_declaration
    ;
parameter_declaration:
    TYPE_INT declarator
    ;

statement:
    ';'
    | expression ';'
    | compound_statement
    | if_statement
    | WHILE '(' expression ')' statement
    | RETURN expression ';'
    ;

if_statement:
    if_else_statement 
    | IF '(' expression ')' statement
    ;

if_else_statement:
    if_statement ELSE statement
    ;

compound_statement:
    '{' '}'
    | '{' statement_list '}'
    | '{' declaration_list '}'
    | '{' declaration_list statement_list '}'
    ;
declaration_list:
    declaration
    | declaration_list declaration
    ;
statement_list:
    statement
    | statement_list statement
    ;

expression:
    assign_expr
    | expression ',' assign_expr
    ;
assign_expr:
    logical_or_expr
    | IDENTIFIER '=' assign_expr
    ;
logical_or_expr:
    logical_and_expr
    | logical_or_expr OP_LOGICAL_OR logical_and_expr
    ;
logical_and_expr:
    equality_expr
    | logical_and_expr OP_LOGICAL_AND equality_expr
    ;

equality_expr:
    relational_expr
    | equality_expr OP_EQUAL relational_expr
    | equality_expr OP_NOT_EQUAL relational_expr
    ;

relational_expr:
    add_expr
    | relational_expr OP_LT add_expr
    | relational_expr OP_GT add_expr
    | relational_expr OP_LTE add_expr
    | relational_expr OP_GTE add_expr
    ;

add_expr:
    mult_expr
    | add_expr OP_PLUS mult_expr
    | add_expr OP_MINUS mult_expr
    ;
mult_expr:
    unary_expr
    | mult_expr OP_TIMES unary_expr
    | mult_expr OP_DIVIDE unary_expr
    ;

unary_expr:
    postfix_expr
    | OP_MINUS unary_expr
    ;

postfix_expr:
    primary_expr
    ;

primary_expr:
    IDENTIFIER
    | constant
    | '(' expression ')'
    ;

constant:
    INTEGER
    ;

%%
extern int yylineno;

int yyerror(char *s) {
    fprintf(stderr, "%d: %s\n", yylineno, s);
    return 0;
}

int main(void) {
    yyparse();

    return 0;
}