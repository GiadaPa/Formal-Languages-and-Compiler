%{
  #include <stdio.h>
  #include <string.h>
  #include "json.lex.c"

  #define CLASS 0
  #define CONTENT 1
  #define TYPE 2
  #define IMAGE 3
  #define BGCOLOR 4
  #define SIZE 5
  #define ABSOLUTE 6
  #define STYLE 7
  #define FILL 8
  #define CHILD 9
  

  typedef struct { char *key; int val; } t_symstruct;

  t_symstruct lookuptable[] = {
      { "name", CLASS },
      { "characters", CONTENT },
      { "type", TYPE },
      { "imageRef", IMAGE },
      { "background-color", BGCOLOR },
      { "height", SIZE },
      { "width", SIZE },
      { "top", SIZE },
      { "bottom", SIZE },
      { "left", SIZE },
      { "right", SIZE },
      { "absoluteBoundingBox", ABSOLUTE },
      { "style", STYLE },
      { "fill", FILL },
      { "children", CHILD },
  };

  #define NKEYS (sizeof(lookuptable)/sizeof(t_symstruct))

  char* decodeKV(char* key, char* value);
  char* decodeObject(char* key, char* values);
  char* decodeArray(char* key, char* value);
  char* checkDIV(char* str);

  char* generatedOutput;

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

start: object { 
              printf($1);
              generatedOutput = $1;
            }

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
              char* result = malloc(strlen($1) + strlen($3) + strlen(" ") + 1);
              strcat(result, $1);
              strcat(result, " ");
              strcat(result, $3);
              $$ = result;
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
              // printf("array\n");
              $$ = decodeArray($1, $3); 
            }
          ;

array: ARRAY_BEGIN elements ARRAY_END { $$ = $2; };

elements: value { $$ = $1; }
          | object { $$ = $1;  }
          | array { $$ = $1;  }
          | value COMMA elements {
              char* result = malloc(strlen($1) + strlen($3) + strlen(" ") + 1);
              strcat(result, $1);
              strcat(result, " ");
              strcat(result, $3);
              $$ = result;
            }
          | object COMMA elements { 
              char* result = malloc(strlen($1) + strlen($3) + strlen(" ") + 1);
              strcat(result, $1);
              strcat(result, " ");
              strcat(result, $3);
              $$ = result;
            }
          | array COMMA elements { 
              char* result = malloc(strlen($1) + strlen($3) + strlen(" ") + 1);
              strcat(result, $1);
              strcat(result, " ");
              strcat(result, $3);
              $$ = result;
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

int main (int argc, char *argv[]) {
  int result = yyparse();
  
  printf("\n");
  if (result == 0) {
    printf("\n\nSUCCESS:: The json file `%s.json` has been successfully transpiled.\n", argv[1]);

    char* filename = malloc(strlen(argv[1]) + strlen(".html") + 1);
    strcat(filename, argv[1]);
    strcat(filename, ".html");

    result = printToFile(filename, generatedOutput);
    if (result == 0) {
      printf("SUCCESS:: The HTML code has been successfully generated in `%s`.\n", filename);
    } else {
      printf("ERROR:: An error occurred in writing `%s`. Program is being closed.\n", filename);
    }

  } else {
    printf("ERROR:: An error occurred in parsing `%s.json`. Program is being closed.\n", argv[1]);
  }

  return 0;
}

int printToFile (char *filename, char *content) {
  FILE *f = fopen(filename, "w");
  if (f == NULL) {
      printf("Error opening file!\n");
      return -1;
  }

  fprintf(f, content);

  fclose(f);

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
    case TYPE:
      if (strcmp(value, "image") == 0) {
        out = malloc(strlen("background-image: ") + 1);
        strcat(out, "background-image: ");
      } else if (strcmp(value, "solid") == 0) {
        out = malloc(strlen("background-color: ") + 1);
        strcat(out, "background-color: ");
      }
      break;
    case IMAGE:
      out = malloc(strlen("url('');") + strlen(value) + 1);
      strcat(out, "url('");
      strcat(out, value);
      strcat(out, "');");
      break;
    case BGCOLOR:
      out = malloc(strlen(";") + strlen(value) + 1);
      strcat(out, value);
      strcat(out, ";");
      break;
    case SIZE:
      out = malloc(strlen(key) + strlen(value) + strlen(": px;") + 1);
      strcat(out, key);
      strcat(out, ": ");
      strcat(out, value);
      strcat(out, "px;");
      break;
    default:
      out = malloc(strlen(key) + strlen(": ;") + strlen(value) + 1);
      strcat(out, key);
      strcat(out, ": ");
      strcat(out, value);
      strcat(out, ";");
      break;
  }

  return out;
}

char* decodeObject(char* key, char* values) {
  char* out;

  switch(lookup(key)) {
    case ABSOLUTE:
      out = malloc(strlen("style=\"position: absolute; \" ") + strlen(values) + 1);
      strcat(out, "style=\"position: absolute; ");
      strcat(out, values);
      strcat(out, "\" ");
      break;
    case STYLE:
      out = malloc(strlen("style=\"\" ") + strlen(values) + 1);
      strcat(out, "style=\"");
      strcat(out, values);
      strcat(out, "\" ");
      break;
    case FILL:
      out = malloc(strlen("style=\"\" ") + strlen(values) + 1);
      strcat(out, "style=\"");
      strcat(out, values);
      strcat(out, "\" ");
      break;
  }

  return out;
}

char* decodeArray(char* key, char* value) {
  char* out;

  switch(lookup(key)) {
    case CHILD:
      out = value;
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
    out = str;
  }

  return out;
}