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
LETTER [a-zA-Z]
LETTERS {LETTER}+
STRING \"\"|\"({LETTERS}|{NUMBER})+\"
BOOLEAN true|false

%%

{STRING} { 
        char* temp = strndup(yytext, strlen(yytext)-1);
        yylval.str = strdup(++temp);
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

// opzione 1 -> yytext[yyleng-1]
// opzione 2 -> strdup(strlen(yytext)-1)
// incrementare con string++
// 
