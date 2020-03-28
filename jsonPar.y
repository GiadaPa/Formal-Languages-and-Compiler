%{
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    #define YYSTYPE char*
    // char *strconcat(char *str1, char *str2);


%}

%union { 
  int integer;
  char *string;
}

%start object

%token <integer>NUMBER
%token <*string>STRING
%token <*string>BOOL
%right OBJECT_BEGIN ARRAY_BEGIN 
%left OBJECT_END ARRAY_END
%left COMMA
%left COLON

%%
object: OBJECT_BEGIN STRING OBJECT_END {
  printf("%s", $2.string);
}
%%


/*
%%
object: OBJECT_BEGIN members OBJECT_END {
    // $$ = (char *)malloc(sizeof(char)*(10 + strlen($2)+2));
    printf("%s", $<string>2);
    // sprintf($$,"{%s}",$2);
  }
;

members: pair {
    $<string>$ = $<string>1;
  }
| pair COMMA members {
    $<string>$ = (char *)malloc(sizeof(char)*(10 + strlen($<string>1)+2 + strlen($<string>3)+2));
    // $$ = $2;
    // sprintf($$,"%s,%s",$1,$3);
  }
;

pair: key COLON value {
    $<string>$ = (char *)malloc(sizeof(char)*(10 + strlen($<string>1)+2 + strlen($<string>3)+2));
    // $$ = $1;
    printf("%s:%s",$<string>1,$<string>3);
    // sprintf($$,"%s:%s",$1,$3);
  }
;

array: ARRAY_BEGIN value ARRAY_END {
    $<string>$ = (char *)malloc(sizeof(char)*(10 + strlen($<string>2)+2));
    // $$ = $2;
    // sprintf($$,"[%s]",$2);
	}
;

key: STRING {
  printf("%s", $1);
  $<string>$ = $1;
};

value: STRING {
    printf("%s", $1);
    $<string>$ = $1; 
  } 
| NUMBER {
    printf("%d", $1);
    $<integer>$ = $1;
  }
| BOOL {
    $<string>$ = $1;
  }
| object {
    $<string>$ = $<string>1;
  }
| array {
    $<string>$ = $1;
  }
;
%%

*/

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
