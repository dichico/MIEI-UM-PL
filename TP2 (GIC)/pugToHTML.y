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

%token HTML TITLE
%token string ERRO

%type <stringValue> string DelcInicial AbreHead ConteudoHead Titulo AtributoHandler Atributos Atributo

%%

FicheiroPug         :   DelcInicial AbreHead                {
                                                                            printf("%s\n%s\n", $1, $2);
                                                                        }
                    ;

DelcInicial         :   HTML AtributoHandler                            { asprintf(&$$, "<html %s>", $2); }
                    ;

AbreHead            :   string                                          {
                                                                            espacosAtuais = contaEspacosIniciais($1);
                                                                            char *aberturaHead = strdup(" ");

                                                                            for(int i = 0; i < espacosAtuais-1; i++)
                                                                                 strcat(aberturaHead, " ");

                                                                            strcat(aberturaHead, "<head>");

                                                                            asprintf(&$$, "%s", aberturaHead); 
                                                                        }
                    ;

ConteudoHead        :   Titulo                                          { asprintf(&$$, "%s", $1); }
                    |   Titulo AtributoHandler                          { asprintf(&$$, "%s\n%s", $1, $2); }
                    ;

Titulo              :   TITLE '"' string '"'                            {

                                                                        }
                    ;

AtributoHandler     :   '(' Atributos ')'                               { asprintf(&$$, "%s", $2); }
                    ;

Atributos           :   Atributos ',' Atributo                          { asprintf(&$$, "%s", $3); }
                    |   Atributo                                        { asprintf(&$$, "%s", $1); }
                    ;

Atributo            :   string                                          { asprintf(&$$, "%s", $1); }
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