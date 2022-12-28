#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef struct var_simbolo{

  int nivel_lexico;
  int ordem;
  char nome[16];
  char tipo[16];
}var_simbolo;

typedef struct tabela_simbolos{
  var_simbolo *tabela;
  int size;
}tabela_simbolos;


void insere(tabela_simbolos *t,
            char *nome,
            char *tipo,
            int nivel_lexico){
  
  if(t->size == 0){
      t->tabela = (var_simbolo *)malloc(sizeof(var_simbolo));
      t->tabela[t->size].ordem = 0;

  }
  else{
    t->tabela = (var_simbolo *)realloc(t->tabela, (t->size + 1) * sizeof(var_simbolo));
    if(t->tabela[t->size - 1].nivel_lexico == nivel_lexico){
      t->tabela[t->size].ordem = t->tabela[t->size - 1].ordem + 1;
    } 
    else{
      t->tabela[t->size].ordem = 0;
    }
  }

  
  t->tabela[t->size].nivel_lexico = nivel_lexico;
  strcpy(t->tabela[t->size].nome, nome);
  strcpy(t->tabela[t->size].tipo, tipo);
  t->size++;
}

void print(tabela_simbolos *t){
  for(int i = 0; i < t->size; i++){
    fprintf(stderr, "%s %s => (%d,%d)  \n", t->tabela[i].tipo, 
                                            t->tabela[i].nome, 
                                            t->tabela[i].nivel_lexico,
                                            t->tabela[i].ordem);
                                          }
}

void pop(tabela_simbolos *t, int n){

  t->size -= n;
  t->tabela = (var_simbolo *)realloc(t->tabela, (t->size) * sizeof(var_simbolo));
}

int busca(tabela_simbolos *t, int nivel_lexico, char *nome){
  for(int i = 0; i < t->size; i++){
    if(t->tabela[i].nivel_lexico == nivel_lexico){
      if(strcmp(nome, t->tabela[i].nome) == 0){
        return t->tabela[i].ordem;
      } 
    }
  }
  return -1;
}




