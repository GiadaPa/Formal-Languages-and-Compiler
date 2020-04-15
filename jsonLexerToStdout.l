/* Compile */
/* flex -l jsonLexerToStdout.l */
/* gcc lex.yy.c */
/* ./a.out */

/* TESTED: it works fine with json syntax*/

%option noyywrap
%{
    #include <stdio.h>
%}

DIGIT [0-9]
DIGITS {DIGIT}+
INT -?{DIGITS}
FRAC \.{DIGITS}
NUMBER {INT}|{INT}{FRAC}
LETTER [a-zA-Z]
LETTERS {LETTER}+
STRING \"\"|\"({LETTERS}|{NUMBER})+\"
BOOLEAN true|false

%%
{STRING} {
    printf("%s", yytext);
}

{NUMBER} {
    printf("%f", atof(yytext));
}

null {
    printf("nullo", yytext);
}

true {
    printf("true__", yytext);
}

false {
    printf("false__", yytext);
}

"{" { 
    printf("\{", yytext);
}

"}" { 
    printf("\}", yytext);
}

"[" { 
    printf("\[", yytext);
}

"]" {  
    printf("\]", yytext);
}

"," { 
    printf("\,", yytext);
}

":" {
    printf("\:", yytext);
}
  
[ \t\n]+ /* ignore whitespace */ {;}

. {
    printf("Unexpected: %c\nExiting...\n",*yytext);
    exit(0);
}

%%

int main(void){
    yylex();
}
