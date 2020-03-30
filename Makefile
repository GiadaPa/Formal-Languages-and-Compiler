# Makefile scanner and parser.

json:   json.l json.y
        bison -vd json.y
        flex -l json.l
        gcc -o $@ json.tab.c lex.yy.c -lfl
