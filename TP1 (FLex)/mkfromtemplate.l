/* Includes e Variáveis */
%{
    #include <string.h>
    #include <stdio.h>
    #include <stdlib.h>
    #include <sys/types.h>
    #include <sys/stat.h>

    char *nome;
    char *email;
    char *autor;

    FILE *ficheiro;
%}

%option noyywrap

/* Definir as SC usadas */
%x META SUB

/* Processamento dos Dados */
%%

"=== meta"\n\n {
    BEGIN META;
}

<META>{
    "email: "[^\n]+ {
        email = strdup(yytext+7);
    }
    "author: "[^\n]+ {
        autor = strdup(yytext+8);
        BEGIN SUB;
    }
}

<SUB>{
    \{"%name%"\}  {
        fprintf(ficheiro, "%s", nome);
    }

    \{"%author%"\} {
        fprintf(ficheiro, "%s", autor);
    }

    \{"%email%"\} {
        fprintf(ficheiro, "%s", email);
    }

    . {
        fprintf(ficheiro, "%s", yytext);
    }
}

%%

/* Função Main */
int main(int argc, char* argv[]){

    if(argc == 3){

        email = autor = "";

        nome = strdup(argv[1]);
        
        yyin = fopen(argv[2], "r");
        ficheiro = fopen("ficheiroLimpo", "w");

        yylex();
    }
    else {
        printf("mkfromtemplate name template");
        return 1;
    }

    return 0;
}