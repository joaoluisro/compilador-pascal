 # -------------------------------------------------------------------
 #            Arquivo: Makefile
 # -------------------------------------------------------------------
 #              Autor: Bruno Müller Junior
 #               Data: 08/2007
 #      Atualizado em: [09/08/2020, 19h:01m]
 #
 # -------------------------------------------------------------------

$DEPURA=1

compilador: lex.yy.c compilador.tab.c compilador.o compilador.h	tabela_simbolos.o
	gcc lex.yy.c compilador.tab.c compilador.o	tabela_simbolos.o -o compilador -ll -ly -lc

lex.yy.c: compilador.l compilador.h
	flex compilador.l

compilador.tab.c: compilador.y compilador.h
	bison compilador.y -d -v

compilador.o : compilador.h compiladorF.c
	gcc -c compiladorF.c -o compilador.o

tabela_simbolos.c: 
	gcc	-c	tabela_simbolos.c	-o	tabela_simbolos.o

clean :
	rm -f compilador.tab.* lex.yy.c compilador.o compilador
