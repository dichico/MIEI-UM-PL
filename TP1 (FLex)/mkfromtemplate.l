/* Includes e Variáveis */
%{
    #include <string.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <sys/types.h>
    #include <sys/stat.h>

    char *name;
    char *email;
    char *author;

    char *nameFile;
%}

%option noyywrap

Portugues   (Á|À|Â|Ã|á|à|â|ã|É|Ê|é|ê|Í|í|Ó|Ô|ó|õ|ô|Ú|ú|ç|[a-zA-Z]|[0-9]|\ )

/* Definir as Start Conditions usadas */
%x META TREE FICHEIRO CONTENT

/* Processamento dos Dados */
%%

"=== meta" {
    BEGIN META;
}

"=== tree" {
    BEGIN TREE;
}

\=+ {
    BEGIN FICHEIRO;
}

<META>{
    "email: "[^\n]+ {
        email = strdup(yytext+7);
    }
    "author: "[^\n]+ {
        author = strdup(yytext+8);
        BEGIN INITIAL;
    }
}

<TREE>{
    ^\{"%name%"\}\/ {
        printf("pastaRaiz");
        // int status = mkdir(rootDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
    ^[a-zA-Z]+\/ {
        printf("pastaRaiz sem name");
        // int status = mkdir(rootDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
    
    ^\-+\ [a-zA-Z]+(\.[a-z]+\n|\n) {
        printf("Ficheiro sem name\n");
        // int lineNumber = countLines(yytext);
    }

    ^\-+\ [a-zA-Z]+\/ {
        printf("Pasta");
        // int status = mkdir(currentDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
    \n\n    {BEGIN INITIAL;}
    
}

<FICHEIRO>{

    [a-zA-Z]+\n {
        printf("testeNomeFicheiro\n");
        nameFile = strdup(yytext);
    }
}

%%

/* Função Main */
int main(int argc, char* argv[]){

    if(argc == 3){

        email = author = "";
        name = strdup(argv[1]);
        
        yyin = fopen(argv[2], "r");

        yylex();
    }
    else {
        printf("mkfromtemplate name template");
        return 1;
    }

    return 0;
}