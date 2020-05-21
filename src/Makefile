# Makefile scanner and parser.

json:   json.l json.y 
	bison -vd json.y
	flex -s json.l
	gcc json.tab.c -lfl
	./a.out $(FILENAME) < $(FILENAME).json