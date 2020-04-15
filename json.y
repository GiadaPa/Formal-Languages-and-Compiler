%{
  #include<stdio.h>
  #include<string.h>
  #include<stdlib.h>
%}

%union { 
  int value;
  struct symtbl *symptr; //definire
}

%token <value> NUMBER
%token <symptr> STRING
%token <symptr> BOOLEAN

%token OBJECT_BEGIN ARRAY_BEGIN 
%token OBJECT_END ARRAY_END
%token COMMA
%token COLON

%type <symptr> object
%type <symptr> members
%type <symptr> pair
%type <symptr> array
%type <symptr> elements
%type <symptr> value

%%

object    : OBJECT_BEGIN OBJECT_END { $$ = {}; }
          |  OBJECT_BEGIN members OBJECT_END { $$ = { $2 }; }
          ;
members   : pair { $$ = $1; }
          | pair COMMA members { $$ = $1, $3; }
          ;
pair      : STRING COLON value { $$ = $1 : $3; }
          ;
array     : ARRAY_BEGIN ARRAY_END { $$ =  []; }
          | ARRAY_BEGIN elements ARRAY_END { $$ = [ $2 ]; }
          ;
elements  : value { $$ = $1; }
          | value COMMA elements { $$ = $1, $3; }
          ;
value     : STRING { $$ = yylval; }
          | NUMBER { $$ = yylval; }
          | object { $$ = $1; }
          | array { $$ = $1; }
          | BOOLEAN { $$ = yylval; }
          ;

%%

#include "lex.yy.c"

void yyerror (char* s) {
  fprintf (stderr, "%s\n", s);
}

int main() {
  yyparse();
  return 0;
}

