%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #define YYSTYPE char*
    // char *strconcat(char *str1, char *str2);


%}

%token NUMBER
%token STRING
%token BOOL
%right OBJECT_BEGIN ARRAY_BEGIN 
%left OBJECT_END ARRAY_END
%left COMMA
%left COLON

%%
START: OBJECT {
    printf("%s", $1);
  }
;

OBJECT: OBJECT_BEGIN MEMBERS OBJECT_END {
    // $$ = (char *)malloc(sizeof(char)*(10 + strlen($2)+2));
    $$ = $2;
    // printf("%s", $2);
    // sprintf($$,"{%s}",$2);
  }
;

MEMBERS: PAIR {
    $$ = $1;
  }
| PAIR COMMA MEMBERS {
    // $$ = (char *)malloc(sizeof(char)*(10 + strlen($1)+2 + strlen($3)+2));
    $$ = $2;
    // sprintf($$,"%s,%s",$1,$3);
  }
;

PAIR: KEY COLON VALUE {
    // $$ = (char *)malloc(sizeof(char)*(10 + strlen($1)+2 + strlen($3)+2));
    $$ = $1;
    printf("%s:%s",$1,$3);
    // sprintf($$,"%s:%s",$1,$3);
  }
;

ARRAY: ARRAY_BEGIN VALUE ARRAY_END {
    // $$ = (char *)malloc(sizeof(char)*(10 + strlen($2)+2));
    $$ = $2;
    // sprintf($$,"[%s]",$2);
	}
;

KEY: STRING {
  printf("%s", yylval);
  $$ = "key";
};

VALUE: STRING {
    printf("%s", "stringa");
    $$="stringa"; 
  } 
| NUMBER {
    printf("%s", "numero");
    $$=yylval;
  }
| BOOL {
  $$=yylval;
  }
| OBJECT {
  $$=$1;
    printf("%s", $1);
  }
| ARRAY {$$=$1;}
;
%%

int main()
{
   printf("\n");
   yyparse();
   printf("\n");
   return 0;
}

int yywrap()
{
   return 1;
}
void yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
}

// char *strconcat(char *str1, char *str2)
// {
//     int len1 = strlen(str1);
//     int len2 = strlen(str2);
//     char *str3 = (char *)malloc(sizeof(char)*(len1+len2+2));
//     strcpy(str3,str1);
//     strcpy(&(str3[len1]),str2);
//     return str3;
// }
