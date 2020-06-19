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
%token beginTag contentTag contentAttribute

%type <stringValue> ContentPugFile
%type <stringValue> Tags Tag TagDefault TagAttribute TagSelfClosing
%type <stringValue> AttributeHandler Attributes Attribute
%type <stringValue> beginTag contentTag contentAttribute

%%

FicheiroPug         :   ContentPugFile                              { printf("%s", $1); }

ContentPugFile      :   Tags                                        { asprintf(&$$, "%s", $1); }
                    ;

Tags                :   Tag '\n' Tags                               { asprintf(&$$, "%s\n%s", $1, $3); }
                    |   Tag                                         { asprintf(&$$, "%s", $1); }
                    ;

Tag                 :   TagDefault                                  { asprintf(&$$, "%s", $1); }
                    |   TagAttribute                                { asprintf(&$$, "%s", $1); }
                    |   TagSelfClosing                              { asprintf(&$$, "%s", $1); }            
                    ;

TagDefault          :   beginTag                                    { asprintf(&$$, "<%s>", $1); }   
                    |   beginTag contentTag                         { asprintf(&$$, "<%s>%s", $1, $2); }
                    |   beginTag '=' contentTag                     { asprintf(&$$, "<%s>%s", $1, $3); }
                    ;

TagAttribute        :   beginTag AttributeHandler                   { asprintf(&$$, "<%s %s>", $1, $2); }   
                    |   beginTag AttributeHandler contentTag        { asprintf(&$$, "<%s %s>%s", $1, $2, $3); }
                    ;

TagSelfClosing      :   beginTag '/'                                { asprintf(&$$, "<%s />", $1); }
                    |   beginTag '/' contentTag                     { asprintf(&$$, "<%s />%s", $1, $3); }
                    |   beginTag AttributeHandler '/'               { asprintf(&$$, "<%s %s />", $1, $2); }
                    |   beginTag AttributeHandler '/' contentTag    { asprintf(&$$, "<%s %s />%s", $1, $2, $4); }
                    ;

AttributeHandler    :   '(' Attributes ')'                          { asprintf(&$$, "%s", $2); }
                    ;

Attributes          :   Attributes ',' Attribute                     { asprintf(&$$, "%s, %s", $1, $3); }
                    |   Attribute                                    { asprintf(&$$, "%s", $1); }
                    ;

Attribute           :   contentAttribute                            { asprintf(&$$, "%s", $1); }
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