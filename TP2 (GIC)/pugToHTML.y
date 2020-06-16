%{
    #include <stdio.h>
    #include <string.h>
    #include "funcoesAux.h"

    extern int yylex();
    extern int yylineno;

    int contaEspacosIniciais(char *texto);
    int yyerror();
    
    int espacosAtuais = 0;
    char *tagAtual;
%}

%union {    
    char *stringValue;
}

%token HTML TITLE
%token string ERRO

%type <stringValue> TITLE string DelcInicial AbreHead ConteudoHead
%type <stringValue> Titulo AtributoHandler Atributos Atributo

%%

FicheiroPug         :   DelcInicial AbreHead ConteudoHead               {
                                                                            printf("%s\n%s\n%s", $1, $2, $3);
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

ConteudoHead        : Titulo                                            { asprintf(&$$, "%s", $1); }
                    | Titulo AtributoHandler
                    ;

Titulo              : TITLE '"' string '"'                              {
                                                                            espacosAtuais = contaEspacosIniciais($1);
                                                                            char *aberturaHead = strdup(" ");

                                                                            for(int i = 0; i < espacosAtuais-1; i++)
                                                                                 strcat(aberturaHead, " ");

                                                                            strcat(aberturaHead, "<title>");

                                                                            asprintf(&$$, "%s%s</title>", aberturaHead, $3); 
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