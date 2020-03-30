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
INT {DIGIT}|{DIGIT}{DIGITS}|-{DIGIT}|-{DIGIT}{DIGITS}
FRAC [.]{DIGITS}
NUMBER {INT}|{INT}{FRAC}
LETTER [a-zA-Z]
LETTERS {LETTER}+
STRING \"\"|\"({LETTERS}|{NUMBER})+\"

%%
{STRING} {
    printf("%s", yytext);
}

{NUMBER} {
    printf("%d", atoi(yytext));
}

null {
    printf("null", yytext);
}

true {
    printf("true", yytext);
}

false {
    printf("false", yytext);
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
