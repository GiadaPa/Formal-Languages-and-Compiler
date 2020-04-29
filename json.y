%{
  #include <stdio.h>
  #include "json.lex.c"
%}

%token <str> NUMBER
%token <str> STRING
%token <str> BOOLEAN
%token OBJECT_BEGIN ARRAY_BEGIN
%token OBJECT_END ARRAY_END
%token COMMA
%token COLON

%type <str> value

%union {
  char *str;
}

%%

object: OBJECT_BEGIN OBJECT_END { printf("hoho"); }
          |  OBJECT_BEGIN members OBJECT_END { printf("init"); }
          ;
members: pair { printf("cacca"); }
          | pair COMMA members { printf("hoho"); }
          ;
pair: STRING COLON value { printf("%s", $1); }
          ;
array: ARRAY_BEGIN ARRAY_END { printf("hoho"); }
          | ARRAY_BEGIN elements ARRAY_END { printf("hoho"); }
          ;
elements: value { printf("hoho"); }
          | value COMMA elements { printf("hoho");  }
          ;
value: STRING { printf("%s", $1); }
          | NUMBER { printf("%s", $1); }
          | object { printf("hoho");  }
          | array { printf("hoho");  }
          | BOOLEAN { printf("hoho");  }
          ;

%%

void yyerror (char* s) {
  fprintf (stderr, "%s\n", s);
}

int main() {
  yyparse();
  return 0;
}

