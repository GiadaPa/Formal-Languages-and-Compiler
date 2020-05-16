%{
  #include <stdio.h>
  #include <string.h>
  #include "json.lex.c"

  #define YYDEBUG 1

  #define CLASS 0
  #define CONTENT 1
  #define STYLE 2

  typedef struct { char *key; int val; } t_symstruct;

  t_symstruct lookuptable[] = {
      { "name", CLASS },
      { "characters", CONTENT },
      { "style", STYLE },
  };

  #define NKEYS (sizeof(lookuptable)/sizeof(t_symstruct))

  char* decodeKV(char* key, char* value);
  char* decodeObject(char* key, char* value);
  char* checkDIV(char* str);

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
%type <str> elements
%type <str> members
%type <str> object
%type <str> array

%union {
  char *str;
}

%start start

%%

start: object { printf($1); }

object: OBJECT_BEGIN members OBJECT_END { 
              // printf("object\n");
              $$ = checkDIV($2); 
            }
          ;

members: pair { 
              // printf("pair\n");
              $$ = $1; 
            }
          | pair COMMA members { 
              // printf("members\n");
              strcat($1, " ");
              strcat($1, $3);
              $$ = $1;
            }
          ;

pair: STRING COLON value {
              // printf("KV\n");
              $$ = decodeKV($1, $3);
            }
          | STRING COLON object {
              // printf("KObj\n");
              $$ = decodeObject($1, $3);
            }
          | STRING COLON array { 
            printf("array\n");
            $$ = $3; 
            }
          ;

array: ARRAY_BEGIN elements ARRAY_END { $$ = $2; };

elements: value { $$ = $1; }
          | object { $$ = $1;  }
          | array { $$ = $1;  }
          | value COMMA elements { 
              strcat($1, " ");
              strcat($1, $3);
              $$ = $1;
            }
          | object COMMA elements { 
              strcat($1, " ");
              strcat($1, $3);
              $$ = $1;
            }
          | array COMMA elements { 
              strcat($1, " ");
              strcat($1, $3);
              $$ = $1;
            }
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
  #if YYDEBUG
    yydebug = 1;
  #endif
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
  char* out;

  switch(lookup(key)) {
    case CLASS:
      out = malloc(strlen(value) + strlen("<div class=\"\" ") + 1);
      strcat(out, "<div class=\"");
      strcat(out, value);
      strcat(out, "\" ");
      break;
    case CONTENT:
      out = malloc(strlen(value) + strlen(">") + 1);
      strcat(out, ">");
      strcat(out, value);
      break;
    default:
      out = malloc(strlen(key) + strlen(": ;") + strlen(value) + 1);
      strcat(out, key);
      strcat(out, ": ");
      strcat(out, value);
      strcat(out, ";");
  }

  return out;
}

char* decodeObject(char* key, char* values) {
  char* out;

  switch(lookup(key)) {
    case STYLE:
      out = malloc(strlen("style=\"\" ") + strlen(values) + 1);
      strcat(out, "style=\"");
      strcat(out, values);
      strcat(out, "\" ");
      break;
  }

  return out;
}

char* checkDIV(char* str) {
  char* out;
  if( strncmp("<div", str, 4) == 0) {
    out = malloc(strlen(str) + strlen("</div>") + 1);
    strcat(out, str);
    strcat(out, "</div>");
  } else {
    return str;
  }

  return out;
}