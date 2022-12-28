
// Testar se funciona corretamente o empilhamento de par�metros
// passados por valor ou por refer�ncia.


%{
#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include "compilador.h"
#include "tabela_simbolos.h"

int num_vars;
int nivel_lexico = 0;
tabela_simbolos t;
int ordem;
char variavel_valida[100];
%}

%token PROGRAM ABRE_PARENTESES FECHA_PARENTESES
%token VIRGULA PONTO_E_VIRGULA DOIS_PONTOS PONTO
%token T_BEGIN T_END VAR IDENT T_ATRIBUICAO
%token NUMERO MAIS MENOS DIVIDE MULTIPLICA
%token IF THEN ELSE
%token WHILE DO FOR GOTO
%token AND OR NOT
%token ARRAY FUNCTION PROCEDURE LABEL TYPE 
%token MAIOR_QUE MENOR_QUE IGUAL DIFERENTE
%token MAIOR_OU_IGUAL MENOR_OU_IGUAL
%%

programa:
             {
             geraCodigo (NULL, "INPP");
             t.size = 0;
             }
             PROGRAM IDENT
             ABRE_PARENTESES lista_idents FECHA_PARENTESES PONTO_E_VIRGULA
             bloco PONTO {
             geraCodigo (NULL, "PARA");
             } 
;

bloco       :
              {num_vars = 0;}
              parte_declara_vars
              { /* AMEM */
               char amem[100];
               sprintf(amem, "AMEM %d",num_vars);
               geraCodigo(NULL, amem);
              }
              comando_composto
              ;




parte_declara_vars:  var 
;


var         : { } VAR declara_vars
            |
;

declara_vars: declara_vars declara_var
            | declara_var
;

declara_var : 
              lista_id_var DOIS_PONTOS
              tipo
              PONTO_E_VIRGULA
;

tipo        : IDENT
;

lista_id_var: lista_id_var VIRGULA IDENT
              { 
               
               insere(&t, token, "int", nivel_lexico);
                 /* insere �ltima vars na tabela de s�mbolos */
               num_vars++;
              }
            | IDENT {
                /* insere vars na tabela de s�mbolos */
               insere(&t, token, "int",nivel_lexico);
               num_vars++;
            }
;

lista_idents: lista_idents VIRGULA IDENT
            | IDENT
;


comando_composto: T_BEGIN{nivel_lexico++;} comandos T_END
                  {
                     nivel_lexico--;
                     char dmem[100];
                     sprintf(dmem, "DMEM %d",num_vars);
                     geraCodigo(NULL, dmem);
                     }

;


comandos: comando
         | comando comandos
;


comando: comando_sem_rotulo
;

comando_sem_rotulo: 
                  | atribuicao

;

atribuicao: IDENT 
            {  
               ordem = busca(&t, nivel_lexico - 1, token);
               if(ordem < 0){
                  printf("ERRO: variavel %s não inicializada", token);
                  return -1;
               }
            }
            T_ATRIBUICAO  expressao  {printf("\n expressao: %s \n", token);} PONTO_E_VIRGULA
;

expressao: expressao_simples
         | expressao_simples relacao expressao_simples 
;

relacao: MAIOR_OU_IGUAL
       | MENOR_OU_IGUAL
       | MAIOR_QUE
       | MENOR_QUE
       | IGUAL
       | DIFERENTE
;

expressao_simples: MAIS  termo complemento_termo 
                 | MENOS termo complemento_termo
                 | termo complemento_termo
;

complemento_termo: 
                 | MAIS termo complemento_termo  {printf("\n hey %s \n", token);} 
                 | MENOS termo complemento_termo
                 | OR termo complemento_termo
;

termo: fator  {printf("\n fator %s \n", token);} complemento_fator

;

complemento_fator: 
                 | MULTIPLICA fator complemento_fator
                 | DIVIDE fator complemento_fator
                 | AND fator complemento_fator
;

fator:  {printf("\n variavel %s \n", token);}  variavel
     | NUMERO
     | ABRE_PARENTESES expressao FECHA_PARENTESES
     | NOT fator
;     

variavel: {
   printf("\n variavel é :%s \n", token);
}IDENT 
;



%%

int main (int argc, char** argv) {
   FILE* fp;
   extern FILE* yyin;

   if (argc<2 || argc>2) {
         printf("usage compilador <arq>a %d\n", argc);
         return(-1);
      }

   fp=fopen (argv[1], "r");
   if (fp == NULL) {
      printf("usage compilador <arq>b\n");
      return(-1);
   }

   char* tabela_simbolos;
   

/* -------------------------------------------------------------------
 *  Inicia a Tabela de S�mbolos
 * ------------------------------------------------------------------- */

   yyin=fp;
   yyparse();

   return 0;
}
