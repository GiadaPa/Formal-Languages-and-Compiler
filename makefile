# Makefile example -- scanner and parser.
# Creates "myprogram" from "jsonl.l", "jsonp.y", and "myprogram.c"
#
    LEX     = flex
    YACC    = bison -y
    YFLAGS  = -d
    objects = jsonl.o jsonp.o myprogram.o

    myprogram: $(objects)
    jsonl.o: jsonl.l jsonp.c
    jsonp.o: jsonp.y
    myprogram.o: myprogram.c