# Makefile example -- scanner and parser.
# Creates "outputfile" from "jsonLex.l", "jsonPar.y", and "outputfile.c"
#
    LEX = flex
    YACC = bison -y
    YFLAGS = -d
    objects = jsonLex.o jsonPar.o outputfile.o

    outputfile: $(objects)
    jsonLex.o: jsonLex.l jsonPar.c
    jsonPar.o: jsonPar.y
    outputfile.o: outputfile.c
