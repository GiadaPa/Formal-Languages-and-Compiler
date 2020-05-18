%option outfile="json.lex.c"
%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "json.tab.h"
%}

DIGIT [0-9]
DIGITS {DIGIT}+
INT -?{DIGITS}
FRAC \.{DIGITS}
NUMBER {INT}|{INT}{FRAC}
LETTER ([a-zA-Z]*-[a-zA-Z]+)
LETTERS {LETTER}+
STRING \"\"|\"({LETTERS}|{NUMBER})+\"
BOOLEAN true|false

%%

{STRING} { 
        yylval.str = strndup(++yytext, strlen(yytext)-2);
        return STRING;
    }

{NUMBER} { yylval.str = strdup(yytext); return NUMBER;}

{BOOLEAN} { yylval.str = strdup(yytext); return BOOLEAN;}

"{" { return OBJECT_BEGIN;}

"}" { return OBJECT_END;}

"[" { return ARRAY_BEGIN;}

"]" { return ARRAY_END;};

"," { return COMMA;}

":" { return COLON;}

[ \t\n]+ /* ignore whitespace */{;}

. {
    printf("Unexpected: %c\nExiting...\n", *yytext);
    exit(0);
}

%%