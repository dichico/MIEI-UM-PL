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

Portugues   (Á|À|Â|Ã|á|à|â|ã|É|Ê|é|ê|Í|í|Ó|Ô|ó|õ|ô|Ú|ú|ç|[a-z]|[A-Z]|[0-9]|\ )

/* Definir as Start Conditions usadas */
%x META TREE FILE CONTENT

/* Processamento dos Dados */
%%

"=== meta" {
    BEGIN META;
}

"=== tree" {
    BEGIN TREE;
}

\=+ {
    BEGIN FILE;
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
        int status = mkdir(rootDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
    ^{Portugues}+\/ {
        int status = mkdir(rootDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
    ^\-+{Portugues}+\/ {
        int lineNumber = countLines(yytext);
        int status = mkdir(currentDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
    ^\-+{Portugues}+\.[a-z]\n {
        int lineNumber = countLines(yytext);
    }
}

<FILE>{
    .+\n {
        nameFile = strdup(yytext);
        BEGIN CONTENT;
    }
}

<CONTENT>{
    [a]
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