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

    char *rootDirectory;
    char *currentDirectory;
%}

%option noyywrap
NAME    \{"%name%"\}
EMAIL   \{"%email%"\}
AUTHOR  \{"%author%"\}

/* Definir as SC usadas */
%x META TREE

/* Processamento dos Dados */
%%

"=== meta" {
    BEGIN META;
}

"=== tree" {
    BEGIN TREE;
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
        rootDirectory = strdup(name);
        strcat(rootDirectory, "/");

        int status = mkdir(rootDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
    ^[a-z]+\/ {
        rootDirectory = strdup(yytext);
        strcat(rootDirectory, "/");

        int status = mkdir(rootDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
    ^\-[ ][a-z]+\/ {
        currentDirectory = strdup(rootDirectory);
        strcat(currentDirectory, yytext+2);

        int status = mkdir(currentDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
}

%%

/* Função Main */
int main(int argc, char* argv[]){

    if(argc == 3){

        rootDirectory = currentDirectory = "";
        email = author = "";
        name = strdup(argv[1]);
        
        yyin = fopen(argv[2], "r");

        yylex();
        printf("%s",currentDirectory);
    }
    else {
        printf("mkfromtemplate name template");
        return 1;
    }

    return 0;
}