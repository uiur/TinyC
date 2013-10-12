YACC=bison
YFLAGS= -d
LEX=flex
LFLAGS=
FILES= tinc.tab.c lex.yy.c
all: parser
parser: $(FILES)
	gcc -o parser $(FILES)

lex.yy.c: tinc.l tinc.tab.h
	$(LEX) $(LFLAGS) tinc.l

tinc.tab.c: tinc.y
	$(YACC) $(YFLAGS) tinc.y
