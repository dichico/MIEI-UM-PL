%{
    #include <stdio.h>
    #include <string.h>
    #include "funcoesAux.h"
    #include "structTags.h"

    extern int yylex();
    extern int yylineno;
    extern char* yytext;

    int contaEspacosIniciais(char *texto);
    int yyerror();

    int auxSpaces = 0;
    Tags *listTags;
%}

%union {    
    char *stringValue;
}

// Apenas são Tokens os Símbolos Terminais (Variáveis e Não Variáveis)
%token HTML
%token beginTag contentTag stringAttribute

%type <stringValue> HTML
%type <stringValue> DeclInicial ContentPugFile
%type <stringValue> Tags Tag AttributeHandler Attributes Atribute
%type <stringValue> beginTag contentTag stringAttribute

%%

FicheiroPug         :   ContentPugFile                          { printf("%s", $1); }

ContentPugFile      :   Tags                                    { asprintf(&$$, "%s", $1); }
                    |
                    ;

Tags                :   Tags Tag                                { asprintf(&$$, "%s\n%s", $1, $2); }
                    |   Tag                                     { asprintf(&$$, "%s", $1); }
                    ;

Tag                 :   beginTag AttributeHandler               { asprintf(&$$, "<%s %s>", $1, $2); }
                    |   beginTag  '/' contentTag
                    |   beginTag '=' '"' contentTag '"'
                    |   beginTag contentTag                     { asprintf(&$$, "<%s> %s", $1, $2); }
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