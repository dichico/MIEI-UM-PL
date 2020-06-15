pugToHTML : y.tab.o lex.yy.o
	gcc -o pugToHTML y.tab.o lex.yy.o -ll

y.tab.o : y.tab.c
	gcc -c y.tab.c

lex.yy.o : lex.yy.c
	gcc -c lex.yy.c

y.tab.c y.tab.h : pugToHTML.y
	yacc -d pugToHTML.y 

lex.yy.c : pugToHTML.l y.tab.h
	flex pugToHTML.l

clean:
	rm -rf lex.yy.c lex.yy.o y.tab.c y.tab.o y.tab.h pugToHTML