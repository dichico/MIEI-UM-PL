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

%token HTML HEAD TITLE LINK BODY
%token initialSpaces string stringAttribute

%type <stringValue> DeclInicial BeginFile ContentHead Body
%type <stringValue> Title Link Links AttributeHandler Attributes Atribute
%type <stringValue> initialSpaces string stringAttribute

%%

FicheiroPug         :   DeclInicial BeginFile                   { printf("%s\n%s", $1, $2); }
                    ;

DeclInicial         :   HTML AttributeHandler                   { asprintf(&$$, "<html %s>", $2); }
                    ;

BeginFile           :   initialSpaces HEAD ContentHead          {
                                                                    actualSpaces = strdup($1);
                                                                    actualTag = strdup("head");
                                                                    asprintf(&$$, "\n%s<head>\n%s\n", $1, $3); 
                                                                }
                    ;

ContentHead         : Title Body                                { asprintf(&$$, "%s\n%s", $1, $2); }
                    | Title Links Body                          { asprintf(&$$, "%s\n%s\n%s", $1, $2, $3); }
                    | Links Title Body                          { asprintf(&$$, "%s\n%s\n%s", $1, $2, $3); }
                    | Links Title Links Body                    { asprintf(&$$, "%s\n%s\n%s\n%s", $1, $2, $3, $4); }
                    ;

Title               :   initialSpaces TITLE stringAttribute     {
                                                                    asprintf(&$$, "%s<title>%s</title>", $1, $3);
                                                                }
                    ;

Links               :   Links Link                              { asprintf(&$$, "%s\n%s", $1, $2); } 
                    |   Link                                    { asprintf(&$$, "%s", $1); }
                    ;

Link                :   initialSpaces LINK AttributeHandler     { asprintf(&$$, "%s<link %s/>", $1, $3); }
                    ;


Body                :   initialSpaces BODY                      { asprintf(&$$, "%s</head>\n\n%s<body>", actualSpaces, $1); }
                    ;

AttributeHandler    :   '(' Attributes ')'                      { asprintf(&$$, "%s", $2); }
                    ;

Attributes          :   Attributes ',' Atribute                 { asprintf(&$$, "%s, %s", $1, $3); }
                    |   Atribute                                { asprintf(&$$, "%s", $1); }
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