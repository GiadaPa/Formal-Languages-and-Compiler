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

  char* decodeKV(char* key, char* value);
  char* decodeObject(char* key, char* value);

%}

%token <str> NUMBER
%token <str> STRING
%token <str> BOOLEAN
%token OBJECT_BEGIN ARRAY_BEGIN
%token OBJECT_END ARRAY_END
%token COMMA
%token COLON

%type <str> value
%type <str> pair
%type <str> members
%type <str> object

%union {
  char *str;
}

%%

object: OBJECT_BEGIN OBJECT_END { printf("hoho"); }
          |  OBJECT_BEGIN members OBJECT_END { checkDIV($2); $$ = $2; }
          ;
members: pair { $$ = $1; }
          | pair COMMA members { 
              $$ = malloc(sizeof($1) + sizeof($3) + 2);
              sprintf($$, "%s %s", $1, $3);
            }
          ;
pair: STRING COLON value { $$ = decodeKV($1, $3); }
          | STRING COLON object { $$ = decodeObject($1, $3);  }
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

char* decodeKV(char* key, char* value) {
  char* out = malloc(100);
  switch(lookup(key)) {
    case K1:
      sprintf(out, "<div class=\"%s\" ", value);
      printf("%s", out);
      break;
    case K2:
      sprintf(out, ">\n\t%s\n", value);
      printf("%s", out);
      break;
    default:
      sprintf(out, "%s: %s; ", key, value);
  }
  return out;
}

char* decodeObject(char* key, char* value) {
  char* out;
  switch(lookup(key)) {
    case OBJ1:
      out = malloc(sizeof("style=\"\"") + sizeof(value) + 2);
      printf("%s%s\"", "style=\"", value);
      break;
    default:
      out = "DEFAULT OBJECT\n";
  }

  return out;
}

void checkDIV(char* str) {
  if( strncmp("<div", str, 4) == 0) {
    printf("</div>");
  };
}