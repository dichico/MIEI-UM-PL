/* Includes e Variáveis */
%{
    #include <string.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <sys/types.h>
    #include <sys/stat.h>
    #include "directories.h"

    char *name;
    char *email;
    char *author;
    char *nameFile;

    Directories *directories; 
%}

%option noyywrap

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
        directories = insertDirectory(directories, isDirectory, strcat(name,"/"));

        char *currentDirectory = lastDirectory(directories);
        int status = mkdir(currentDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }

    ^[a-zA-Z]+\/ {
        directories = insertDirectory(directories, isDirectory, strdup(yytext));
        
        char *currentDirectory = lastDirectory(directories);
        int status = mkdir(currentDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }
    
    ^\-+\ [a-zA-Z]+\.[a-z]+ {
        directories = insertDirectory(directories, isFile, strdup(yytext));

        char *currentDirectory = lastDirectory(directories);
        FILE *newFile = fopen(currentDirectory, "w");
        fclose(newFile);
    }

    ^\-+\ \{"%name%"\}\.[a-z]+ {
        printf("LOL %s\n", yytext-3);        
    }

    ^\-+\ [a-zA-Z]+\/ {
        directories = insertDirectory(directories, isDirectory, strdup(yytext));
        
        char *currentDirectory = lastDirectory(directories);
        int status = mkdir(currentDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
    }

    ===\     {BEGIN FICHEIRO;}
    
}

<FICHEIRO>{
    [a-zA-Z%{}\.]+ {
        //printf("testeNomeFicheiro\n");
        nameFile = strdup(yytext);
    }

    \n  {BEGIN CONTENT;}
    
}

<CONTENT>{
    [^=]+ {
        //printf("conteúdo\n");
    } 
    ===\    {BEGIN FICHEIRO;}
}

%%

/* Função Main */
int main(int argc, char* argv[]){

    if(argc == 3){

        // Global Variables Values
        email = author = "";
        name = strdup(argv[1]);
        directories = init();

        // Open template file
        yyin = fopen(argv[2], "r");
        
        // FLex Process
        yylex();

        printDirectories(directories);

    }   
    else {
        printf("mkfromtemplate name template");
        return 1;
    }

    return 0;
}