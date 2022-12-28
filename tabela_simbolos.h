#ifndef TABELA_SIMBOLOS_HEADER

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
            int nivel_lexico);

void print(tabela_simbolos *t);

void pop(tabela_simbolos *t, int n);

int busca(tabela_simbolos *t, int nivel_lexico, char *nome);



#endif