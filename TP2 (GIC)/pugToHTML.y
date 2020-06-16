%{
    #include <stdio.h>
    #include <string.h>
    #include "funcoesAux.h"

    extern int yylex();
    extern int yylineno;

    int contaEspacosIniciais(char *texto);
    int yyerror();
    
    int espacosAtuais = 0;
    int espacosAux = 0;
    char *tagAtual;
%}

%union {    
    char *stringValue;
}

%token HTML TITLE
%token string ERRO

%type <stringValue> TITLE string DelcInicial AbreHead ConteudoHead AbreBody
%type <stringValue> Titulo AtributoHandler Atributos Atributo

%%

FicheiroPug         :   DelcInicial AbreHead ConteudoHead AbreBody      {
                                                                            printf("%s\n%s\n%s\n%s", $1, $2, $3, $4);
                                                                        }
                    ;

DelcInicial         :   HTML AtributoHandler                            { asprintf(&$$, "<html %s>", $2); }
                    ;

AbreHead            :   string                                          {
                                                                            espacosAtuais = contaEspacosIniciais($1);
                                                                            tagAtual = strdup("head");
                                                                            
                                                                            char *aberturaHead = strdup(" ");

                                                                            for(int i = 0; i < espacosAtuais-1; i++)
                                                                                 strcat(aberturaHead, " ");

                                                                            strcat(aberturaHead, "<head>");

                                                                            asprintf(&$$, "%s", aberturaHead); 
                                                                        }
                    ;

ConteudoHead        :   Titulo                                          { asprintf(&$$, "%s", $1); }
                    |   Titulo AtributoHandler
                    ;

AbreBody            :   string                                          {
                                                                            // Fechar a Tag do Head
                                                                            char *fechoHead = strdup(" ");

                                                                            for(int i = 0; i < espacosAtuais-1; i++)
                                                                                 strcat(fechoHead, " ");
                                                                            
                                                                            strcat(fechoHead, "</head>");

                                                                            // Abrir a Tag do Body
                                                                            espacosAtuais = contaEspacosIniciais($1);
                                                                            char *aberturaBody = strdup(" ");

                                                                            for(int i = 0; i < espacosAtuais-1; i++)
                                                                                 strcat(aberturaBody, " ");

                                                                            strcat(aberturaBody, "<body>");

                                                                            asprintf(&$$, "%s\n%s", fechoHead, aberturaBody); 
                                                                        }

Titulo              :   TITLE '"' string '"'                            {
                                                                            espacosAux = contaEspacosIniciais($1);
                                                                            char *aberturaHead = strdup(" ");

                                                                            for(int i = 0; i < espacosAux-1; i++)
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

Atributo            :   string '=' '"' string '"'                              { asprintf(&$$, "%s=\"%s\"", $1, $4); }
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