%{
    #include <stdio.h>
    #include <string.h>
    #include "funcoesAux.h"

    extern int yylex();
    extern int yylineno;

    int yyerror();
    int espacosAtuais = 0;
    char *tagAtual;
%}

%union {    
    char *stringValue;
}

%token HTML
%token string ERRO

%type <stringValue> string DelcInicial Head AtributoHandler Atributos Atributo

%%

FicheiroPug         :   DelcInicial AbreHead                {
                                                                espacosAtuais = contaEspacosIniciais($2); 
                                                                printf("Espacos Head %i", espacosAtuais); 
                                                            }
                    ;

Head                : string                                { asprintf(&$$, "%s", $1); }
                    ;

DelcInicial         :   HTML AtributoHandler                { asprintf(&$$, "<html %s>", $2); }
                    ;


AtributoHandler     :   '(' Atributos ')'                   { asprintf(&$$, "%s", $2); }
                    ;

Atributos           :   Atributos ',' Atributo              { asprintf(&$$, "%s", $3); }
                    |   Atributo                            { asprintf(&$$, "%s", $1); }
                    ;

Atributo            :   string                              { asprintf(&$$, "%s", $1); }
                    ;

%%

int main() {

    yyparse();

    return 0;
}

int yyerror() {
    
    printf("Erro Sintático ou Léxico na linha: %d\n", yylineno);

    return 0;
}