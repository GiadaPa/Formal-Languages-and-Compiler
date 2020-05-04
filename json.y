%{
  #include <stdio.h>
  #include <string.h>
  #include "json.lex.c"

  #define K1 0
  #define K2 1
  #define OBJ1 2

  typedef struct { char *key; int val; } t_symstruct;

  t_symstruct lookuptable[] = {
      { "\"name\"", K1 },
      { "\"content\"", K2 },
      { "\"style\"", OBJ1 },
  };

  #define NKEYS (sizeof(lookuptable)/sizeof(t_symstruct))

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
          |  OBJECT_BEGIN members OBJECT_END { printf("OBJECTwithMEMBER\n"); }
          ;
members: pair { printf("cacca"); }
          | pair COMMA members { printf("hoho"); }
          ;
pair: STRING COLON value { decodeKV($1, $3); }
          | STRING COLON object { decodeObject($1);  }
          | STRING COLON array { printf("hoho");  }
          ;
array: ARRAY_BEGIN ARRAY_END { printf("hoho"); }
          | ARRAY_BEGIN elements ARRAY_END { printf("hoho"); }
          ;
elements: value { printf("hoho"); }
          | value COMMA elements { printf("hoho");  }
          ;
value: STRING { $$ = $1; }
          | NUMBER { $$ = $1; }
          | BOOLEAN { $$ = $1;  }
          ;

%%

void yyerror (char* s) {
  fprintf (stderr, "%s\n", s);
}

int main() {
  yyparse();
  return 0;
}

int lookup(char *key)
{
    int i;
    for (i=0; i < NKEYS; i++) {
        t_symstruct sym = lookuptable[i];
        if (strcmp(sym.key, key) == 0)
            return sym.val;
    }
    return -1;
}

void decodeKV(char* key, char* value) {

  switch(lookup(key)) {
    case K1:
      printf("<div class=\"%s\" \n", value);
      break;
    case K2:
      printf(">%s\n", value);
      break;
    default:
      printf("%s: %s;\n", key, value);
  }
}

void decodeObject(char* key) {
  switch(lookup(key)) {
    case OBJ1:
      printf("CASEOBJ1\n");
      break;
    default:
      printf("DEFAULT OBJECT\n");
  }
}
