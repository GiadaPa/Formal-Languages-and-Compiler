%{
    #include <stdio.h>
    #include "y.tab.h"
    char *strclone(char *str);
    
%}

DIGIT [0-9]
DIGITS {DIGIT}+
INT {DIGIT}|{DIGIT}{DIGITS}|-{DIGIT}|-{DIGIT}{DIGITS}
FRAC [.]{DIGITS}
NUMBER {INT}|{INT}{FRAC}
LETTER [a-zA-Z]
LETTERS {LETTER}+
DBL_QUOTE ["]
STRING {DBL_QUOTE}{DBL_QUOTE}|{DBL_QUOTE}{LETTERS}{DBL_QUOTE}

%%
{STRING} {
    char* yylval = strclone(yytext);
    return STRING;
};

{NUMBER} {
    yylval=atoi(yytext);
    return NUMBER;
};

true|false {
    char* yylval=strclone(yytext);
    return BOOL;
};

\{ {
    return OBJECT_BEGIN;
};

\} {
    return OBJECT_END;
};

\[ {
    return ARRAY_BEGIN;
};

\] {
    return ARRAY_END;
};

, {
    return COMMA;
};

: {
    return COLON;
};

[ \t\n]+ /* ignore whitespace */;

. {
    printf("Unexpected: %c\nExiting...\n",*yytext);
    exit(0);
}
%%

char *strclone(char *str)
{
    int len = strlen(str);
    char *clone = (char *)malloc(sizeof(char)*(len+1));
    strcpy(clone,str);
    return clone;
}
