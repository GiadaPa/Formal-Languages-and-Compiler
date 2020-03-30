%option noyywrap
%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "json.tab.h"
    #include "json.tab.c"
%}

DIGIT [0-9]
DIGITS {DIGIT}+
INT {DIGIT}|{DIGIT}{DIGITS}|-{DIGIT}|-{DIGIT}{DIGITS}
FRAC [.]{DIGITS}
NUMBER {INT}|{INT}{FRAC}
LETTER [a-zA-Z]
LETTERS {LETTER}+
STRING \"\"|\"({LETTERS}|{NUMBER})+\"
BOOLEAN true|false

%%

{STRING} { yylval.symptr = symlookup(yytext); return (STRING);}

{NUMBER} { yylval.value = atof(yytext); return (NUMBER);}

{BOOLEAN} { yylval.symptr = symlookup(yytext); return (BOOLEAN);}

"{" { return (OBJECT_BEGIN);}

"}" { return (OBJECT_END);}

"[" { return (ARRAY_BEGIN);}

"]" { return (ARRAY_END);};

"," { return (COMMA);}

":" { return (COLON);}

[ \t\n]+ /* ignore whitespace */{;}

. {
    printf("Unexpected: %c\nExiting...\n", *yytext);
    exit(0);
}

%%
