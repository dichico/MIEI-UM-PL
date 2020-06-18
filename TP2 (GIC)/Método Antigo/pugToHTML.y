%{
    #include <stdio.h>
    #include <string.h>
    #include "funcoesAux.h"

    extern int yylex();
    extern int yylineno;
    extern char* yytext;

    int contaEspacosIniciais(char *texto);
    int yyerror();
    
    extern int actualSpaces = 0;
    int auxSpaces = 0;
    char *actualTag;
%}

%union {    
    char *stringValue;
}

%token HTML HEAD TITLE LINK BODY HEADER
%token initialHead initialTitle initialLink initialBody initialHeader string stringAttribute

%type <stringValue> DeclInicial ContentPugFile Head ContentHead Body ContentBody
%type <stringValue> Title Link Links AttributeHandler Attributes Atribute
%type <stringValue> initialHead initialTitle initialLink initialBody initialHeader string stringAttribute

%%

FicheiroPug         :   DeclInicial ContentPugFile              { printf("%s\n%s", $1, $2); }
                    ;

DeclInicial         :   HTML AttributeHandler                   { asprintf(&$$, "<html %s>", $2); }
                    ;

ContentPugFile      :   Head                                    { asprintf(&$$, "%s", $1); }
                    ;

Head                :   initialHead ContentHead                 { 
                                                                    auxSpaces = contaEspacosIniciais($1);
                                                                    actualSpaces = auxSpaces;

                                                                    char *openTagHead = strdup(" ");

                                                                    for(int i = 0; i < auxSpaces-1; i++)
                                                                        strcat(openTagHead, " ");

                                                                    strcat(openTagHead, "<head>");
                                                                    asprintf(&$$, "%s\n%s", openTagHead, $2); 
                                                                }
                    ;

ContentHead         :   Title Body                              { asprintf(&$$, "%s\n%s", $1, $2); }
                    |   Title Links Body                        { asprintf(&$$, "%s\n%s\n%s", $1, $2, $3); }
                    |   Links Title Body                        { asprintf(&$$, "%s\n%s\n%s", $1, $2, $3); }
                    |   Links Title Links Body                  { asprintf(&$$, "%s\n%s\n%s\n%s", $1, $2, $3, $4); }
                    ;

Title               :   initialTitle stringAttribute            {
                                                                    auxSpaces = contaEspacosIniciais($1);
                                                                    char *openTagTitle = strdup(" ");

                                                                    for(int i = 0; i < auxSpaces-1; i++)
                                                                        strcat(openTagTitle, " ");

                                                                    strcat(openTagTitle, "<title>");
                                                                    asprintf(&$$, "%s%s</title>", openTagTitle, $2); 
                                                                }
                    ;

Links               :   Links Link                              { asprintf(&$$, "%s\n%s", $1, $2); } 
                    |   Link                                    { asprintf(&$$, "%s", $1); }
                    ;

Link                :   initialLink AttributeHandler            {
                                                                    auxSpaces = contaEspacosIniciais($1);
                                                                    char *openTagLink = strdup(" ");

                                                                    for(int i = 0; i < auxSpaces-1; i++)
                                                                        strcat(openTagLink, " ");

                                                                    strcat(openTagLink, "<link");
                                                                    asprintf(&$$, "%s %s/>", openTagLink, $2); 
                                                                }
                    ;

Body                :   initialBody ContentBody                 {
                                                                    // Fechar a Tag do Head
                                                                    auxSpaces = contaEspacosIniciais($1);
                                                                    char *closeTagHead = strdup(" ");

                                                                    for(int i = 0; i < auxSpaces-1; i++)
                                                                        strcat(closeTagHead, " ");
                                                                    
                                                                    strcat(closeTagHead, "</head>");

                                                                    // Abrir a Tag do Body
                                                                    char *openTagBody = strdup(" ");

                                                                    for(int i = 0; i < auxSpaces-1; i++)
                                                                        strcat(openTagBody, " ");

                                                                    strcat(openTagBody, "<body>");
                                                                    asprintf(&$$, "%s\n%s\n%s", closeTagHead, openTagBody, $2); 
                                                                }
                    ;

ContentBody         :   initialHeader string                    { 
                                                                    auxSpaces = contaEspacosIniciais($1);
                                                                    char *openTagHeader = strdup(" ");

                                                                    for(int i = 0; i < auxSpaces-1; i++)
                                                                        strcat(openTagHeader, " ");

                                                                    strcat(openTagHeader, "<h1>");
                                                                    asprintf(&$$, "%s%s</h1>", openTagHeader, $2);                                                                 
                                                                }
                    ;

AttributeHandler    :   '(' Attributes ')'                      { asprintf(&$$, "%s", $2); }
                    ;

Attributes          :   Attributes ',' Atribute                 { asprintf(&$$, "%s, %s", $1, $3); }
                    |   Atribute                                { asprintf(&$$, "%s", $1); }
                    ;

Atribute            :   stringAttribute                         { asprintf(&$$, "%s", $1); }
                    ;

%%

int main() {

    yyparse();
    return 0;
}

int yyerror() {
    
    printf("Erro Sintático ou Léxico na linha: %d com o texto: %s\n", yylineno, yytext);
    return 0;
}