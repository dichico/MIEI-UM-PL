/* Includes e Variáveis */
%{
    #include <string.h>
    #include <stdlib.h>
    #include <sys/types.h>
    #include <sys/stat.h>

    char *diretoriaAtual;
    char *email;
    char *autor;
    char *nome;
%}

%option noyywrap

/* Definir as SC usadas */
%x META TREE FICHEIRO

/* Processamento dos Dados */
%%

"=== meta"\n {
    BEGIN META;
}

"=== tree"\n {
    BEGIN TREE;
}

<META>{
    "email: "[^\n]+ {
        email = strdup(yytext+7);
    }
    "author: "[^\n]+ {
        autor = strdup(yytext+8);
        BEGIN INITIAL;
    }
}

<TREE>{
    ^\{\%[a-z]+\%\}\/ {
        int status;
        status = mkdir(nome, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
}

"=== "[a-zA-Z]+ {
    BEGIN FICHEIRO;
}

"{%name%}"  {
    printf("%s", nome);
}

"{%author%}" {
    printf("%s", autor);
}

"{%email%}" {
    printf("%s", email);
}
%%

/* Função Main */
int main(int argc, char* argv[]){

    if(argc == 3){

        email = autor = diretoriaAtual = "";

        nome = strdup(argv[1]);
        
        yyin = fopen(argv[2], "r");

        yylex();

        printf("Nome: %s\n", nome);
        printf("Email: %s\n", email);
        printf("Author: %s\n", autor);
        printf("Diretoria: %s\n", diretoriaAtual);

    }
    else {
        printf("mkfromtemplate name template");
        return 1;
    }

    return 0;
}