%{
    #include <stdio.h>
    #include <string.h>
    #include "funcoesAux.h"

    extern int yylex();
    extern int yylineno;
    extern char* yytext;

    int contaEspacosIniciais(char *texto);
    int yyerror();
    
    int actualSpaces;
    char *actualTag;
%}

%union {    
    char *stringValue;
}

%token HTML HEAD TITLE LINK BODY HEADER
%token initialHead initialTitle initialLink initialBody initialHeader string stringTitle stringAttribute

%type <stringValue> DeclInicial ContentPugFile Head ContentHead Body ContentBody
%type <stringValue> Title Link Links AttributeHandler Attributes Atribute
%type <stringValue> initialHead initialTitle initialLink initialBody initialHeader string stringTitle stringAttribute

%%

FicheiroPug         :   DeclInicial ContentPugFile              { printf("%s\n%s", $1, $2); }
                    ;

DeclInicial         :   HTML AttributeHandler                   { asprintf(&$$, "<html %s>", $2); }
                    ;

ContentPugFile      :   Head                                    { asprintf(&$$, "%s", $1); }
                    ;

Head                :   initialHead ContentHead                 {
                                                                    actualSpaces = contaEspacosIniciais($1);
                                                                    actualTag = strdup("head");
                                                                    
                                                                    char *aberturaHead = strdup(" ");

                                                                    for(int i = 0; i < actualSpaces-1; i++)
                                                                            strcat(aberturaHead, " ");

                                                                    strcat(aberturaHead, "<head>");
                                                                    asprintf(&$$, "%s", aberturaHead);
                                                                }
                    ;

ContentHead         :   Title Body                              { asprintf(&$$, "%s\n%s", $1, $2); }
                    |   Title Links Body                        { asprintf(&$$, "%s\n%s\n%s", $1, $2, $3); }
                    |   Links Title Body                        { asprintf(&$$, "%s\n%s\n%s", $1, $2, $3); }
                    |   Links Title Links Body                  { asprintf(&$$, "%s\n%s\n%s\n%s", $1, $2, $3, $4); }
                    ;

Title               :   initialTitle '"' string '"'             {
                                                                    actualSpaces = contaEspacosIniciais($1);
                                                                    char *aberturaTitle = strdup(" ");

                                                                    for(int i = 0; i < actualSpaces-1; i++)
                                                                            strcat(aberturaTitle, " ");

                                                                    strcat(aberturaTitle, "<title>");
                                                                    asprintf(&$$, "%s%s</title>", aberturaTitle, $3); 
                                                                }
                    ;

Links               :   Links Link                              { asprintf(&$$, "%s\n%s", $1, $2); } 
                    |   Link                                    { asprintf(&$$, "%s", $1); }
                    ;

Link                :   initialLink AttributeHandler            { asprintf(&$$, "%s<link %s/>", $1-4, $1); }
                    ;


Body                :   initialBody ContentBody                 { printf("LOL%sLOL", $1);asprintf(&$$, "%s</head>\n\n%s<body>\n%s", actualSpaces, $1-4, $1); }
                    ;

ContentBody         :   initialHeader string                    { asprintf(&$$, "%s<h1>%s", $1-2, $1); }
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