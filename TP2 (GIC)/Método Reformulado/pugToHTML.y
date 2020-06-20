%{
    #include <stdio.h>
    #include <string.h>
    #include "funcoesAux.h"
    #include "structTags.h"

    extern int yylex();
    extern int yylineno;
    extern char* yytext;

    int countInitialSpaces(char *text);
    char *tagWithSpaces(char *text, int initialOrFinal);

    int yyerror();

    int auxSpaces = 0;
    char *auxInitialTag;
    char *auxFinalTag;

    Tags *listTags;
%}

%union {    
    char *stringValue;
}

// Apenas são Tokens os Símbolos Terminais (Variáveis e Não Variáveis)
%token beginTag contentTag contentPipedTag contentAttributes

%type <stringValue> ContentPugFile
%type <stringValue> Tags Tag TagDefault TagAttribute TagSelfClosing
%type <stringValue> AttributeHandler Attributes Attribute
%type <stringValue> beginTag contentTag contentPipedTag contentAttributes

%%

FicheiroPug         :   ContentPugFile                                  { printf("%s", $1); }

ContentPugFile      :   Tags                                            { asprintf(&$$, "%s", $1); }
                    ;

Tags                :   Tag '\n' Tags                                   { asprintf(&$$, "%s\n%s", $1, $3); }
                    |   Tag                                             { asprintf(&$$, "%s", $1); }
                    ;

Tag                 :   TagDefault                                      { asprintf(&$$, "%s", $1); }
                    |   TagAttribute                                    { asprintf(&$$, "%s", $1); }
                    |   TagSelfClosing                                  { asprintf(&$$, "%s", $1); }            
                    ;

TagDefault          :   beginTag                                        { 
                                                                            auxSpaces = countInitialSpaces($1);
                                                                            auxInitialTag = tagWithSpaces($1, 1);
                                                                            auxFinalTag = tagWithSpaces($1, 0);

                                                                            asprintf(&$$, "%s", auxInitialTag); 
                                                                        }   
                    |   beginTag contentTag                             { asprintf(&$$, "<%s>%s", $1, $2); }
                    |   beginTag '=' contentTag                         { asprintf(&$$, "<%s>%s", $1, $3); }
                    ;

TagAttribute        :   beginTag AttributeHandler                       { asprintf(&$$, "<%s %s>", $1, $2); }   
                    |   beginTag AttributeHandler contentTag            { asprintf(&$$, "<%s %s>%s", $1, $2, $3); }
                    |   beginTag AttributeHandler '=' contentTag        { asprintf(&$$, "<%s %s>%s", $1, $2, $4); }
                    ;

TagSelfClosing      :   beginTag '/'                                    { asprintf(&$$, "<%s />", $1); }
                    |   beginTag '/' contentTag                         { asprintf(&$$, "<%s />%s", $1, $3); }
                    |   beginTag '/' '=' contentTag                     { asprintf(&$$, "<%s />%s", $1, $4); }
                    |   beginTag AttributeHandler '/'                   { asprintf(&$$, "<%s %s />", $1, $2); }
                    |   beginTag AttributeHandler '/' contentTag        { asprintf(&$$, "<%s %s />%s", $1, $2, $4); }
                    |   beginTag AttributeHandler '/' '=' contentTag    { asprintf(&$$, "<%s %s />%s", $1, $2, $5); }
                    ;

TagWithBlocks       :   beginTag    
                    ;

AttributeHandler    :   '(' Attributes ')'                              { asprintf(&$$, "%s", $2); }
                    ;

Attributes          :   contentAttributes                               { asprintf(&$$, "%s", $1); }
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