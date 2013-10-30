YACC=bison
YFLAGS= -d
CC=clang
LEX=flex
LFLAGS=
FILES= expression.cc parser.cc tinc.cc lex.yy.cc 
all: parser
parser: $(FILES)
	g++ -o parser $(FILES)

lex.yy.o: lex.yy.cc
	$(CC) -c lex.yy.cc -o lex.yy.o

lex.yy.cc: tinc.l tinc.hh
	$(LEX) $(LFLAGS) -o lex.yy.cc tinc.l

tinc.cc: tinc.y
	$(YACC) $(YFLAGS) tinc.y -o tinc.cc
