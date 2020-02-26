%{
    #include <stdio.h>
    #include "json.tab.h"
    char *strclone(char *str);
    

    #define STRING "str"
    #define NUMBER "number"
    #define OBJECT_BEGIN "object_begin"
    #define OBJECT_END "object_end"
    #define ARRAY_BEGIN "array_begin"
    #define ARRAY_END "array_end"
    #define COMMA "comma"
    #define COLON "colon" 
%}

DIGIT [0-9]
DIGITS {DIGIT}+
INT {DIGIT}|{DIGIT}{DIGITS}|-{DIGIT}|-{DIGIT}{DIGITS}
FRAC [.]{DIGITS}
// EXP {E}{DIGITS}
// E [eE][+-]?
// HEX_DIGIT [0-9a-f]
NUMBER {INT}|{INT}{FRAC}
LETTER [a-zA-Z]
LETTERS {LETTER}+
//UNESCAPEDCHAR [ -!#-\[\]-~]
//ESCAPEDCHAR \\["\\bfnrt/]
//UNICODECHAR \\u{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}{HEX_DIGIT}
//CHAR {UNESCAPEDCHAR}|{ESCAPEDCHAR}|{UNICODECHAR}
//CHARS {CHAR}+
DBL_QUOTE ["]

%%
{DBL_QUOTE}{DBL_QUOTE} |
{DBL_QUOTE}{LETTERS}{DBL_QUOTE} {
    yylval=strclone(yytext);
    return STRING;
};

{NUMBER} {
    yylval=strclone(yytext);
    return NUMBER;
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
