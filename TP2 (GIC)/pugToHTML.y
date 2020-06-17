%{
    #include <stdio.h>
    #include <string.h>
    #include "funcoesAux.h"

    extern int yylex();
    extern int yylineno;
    extern char* yytext;

    int contaEspacosIniciais(char *texto);
    int yyerror();
    
    char *actualSpaces;
    char *actualTag;
%}

%union {    
    char *stringValue;
}

%token HTML HEAD TITLE LINK BODY ERRO
%token initialSpaces string stringAttribute

%type <stringValue> DeclInicial OpenHead ContentHead OpenBody ContentBody
%type <stringValue> Title Link Links AttributeHandler Attributes Atribute
%type <stringValue> initialSpaces string stringAttribute ERRO

%%

FicheiroPug         :   DeclInicial OpenHead ContentHead OpenBody                   {
                                                                                        printf("%s\n%s\n%s\n%s", $1, $2, $3, $4);
                                                                                    }
                    ;

DeclInicial         :   HTML AttributeHandler                   { 
                                                                    asprintf(&$$, "<html %s>", $2); 
                                                                }
                    ;

OpenHead            :   initialSpaces HEAD                      {
                                                                    actualSpaces = strdup($1);
                                                                    actualTag = strdup("head");

                                                                    asprintf(&$$, "%s<head>", $1); 
                                                                }
                    ;

ContentHead         :   Title                                   { asprintf(&$$, "%s", $1); }
                    |   Title Link                              { asprintf(&$$, "%s\n%s", $1, $2); }
                    ;

Title               :   initialSpaces TITLE stringAttribute     {
                                                                    asprintf(&$$, "%s<title>%s</title>", $1, $3);
                                                                }
                    ;

Links               :   Link Links                              { asprintf(&$$, "%s\n%s", $1, $2); }  
                    |   Link                                    { asprintf(&$$, "%s", $1); } 
                    |
                    ;

Link                :   initialSpaces LINK AttributeHandler     { 
                                                                    asprintf(&$$, "%s<link %s/>", $1, $3); 
                                                                }
                    ;

OpenBody            :   initialSpaces BODY                      {
                                                                    asprintf(&$$, "%s</head>\n%s<body>", actualSpaces, $1);
                                                                }

AttributeHandler    :   '(' Attributes ')'                      { 
                                                                    asprintf(&$$, "%s", $2); 
                                                                }
                    ;

Attributes          :   Attributes ',' Atribute                 { asprintf(&$$, "%s, %s", $1, $3); }
                    |   Atribute                                { asprintf(&$$, "%s", $1); }
                    |
                    ;

Atribute            :   string '=' stringAttribute              { asprintf(&$$, "%s=%s", $1, $3); }
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