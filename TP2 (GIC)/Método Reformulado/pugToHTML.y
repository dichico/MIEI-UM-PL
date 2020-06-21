%{
    #include <stdio.h>
    #include <string.h>

    #include "funcoesAux.c"
    #include "funcoesAux.h"

    #include "structTags.h"

    extern int yylex();
    extern int yylineno;
    extern char* yytext;

    int yyerror();

    int numberSpaces = 0;
    char *initialTag;
    char *finalTag;
    char *auxnewInitialTag;

    Tags *listTags;
%}

%union {    
    char *stringValue;
}

// Apenas são Tokens os Símbolos Terminais (Variáveis e Não Variáveis)
%token beginTag contentTag contentPipedTag contentAttributes

%type <stringValue> ContentPugFile
%type <stringValue> Tags Tag TagDefault TagAttribute TagSelfClosing
%type <stringValue> AttributeHandler Attributes
%type <stringValue> beginTag contentTag contentPipedTag contentAttributes

%%

FicheiroPug         :   ContentPugFile                                  {
                                                                            printf("%s", $1);
                                                                            printFinalTags(listTags);
                                                                        }

ContentPugFile      :   Tags                                            { asprintf(&$$, "%s", $1); }
                    ;

Tags                :   Tag '\n' Tags                                   { asprintf(&$$, "%s\n%s", $1, $3); }
                    |   Tag                                             { asprintf(&$$, "%s", $1); }
                    ;

Tag                 :   TagDefault                                      { 
                                                                            asprintf(&$$, "%s", $1); 
                                                                        }
                    |   TagAttribute                                    { 
                                                                            asprintf(&$$, "%s", $1); 
                                                                        }
                    |   TagSelfClosing                                  { asprintf(&$$, "%s", $1); }            
                    ;

TagDefault          :   beginTag                                        { 
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 0, numberSpaces);
                                                                            finalTag = tagWithSpaces($1, 0, 0, numberSpaces);
                                                                            
                                                                            listTags = insertTag(listTags, numberSpaces, finalTag);
                                                                            auxnewInitialTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);

                                                                            asprintf(&$$, "%s", auxnewInitialTag);
                                                                        }   
                    |   beginTag contentTag                             {
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 0, numberSpaces);
                                                                            finalTag = tagWithSpaces($1, 0, 0, numberSpaces);
                                                                            
                                                                            listTags = insertTag(listTags, numberSpaces, finalTag);
                                                                            auxnewInitialTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);

                                                                            asprintf(&$$, "%s%s", auxnewInitialTag, $2);
                                                                        }
                    |   beginTag '=' contentTag                         { asprintf(&$$, "<%s>%s", $1, $3); }
                    ;

TagAttribute        :   beginTag AttributeHandler                       { 
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 1, numberSpaces);
                                                                            finalTag = tagWithSpaces($1, 0, 1, numberSpaces);
                                                                            
                                                                            listTags = insertTag(listTags, numberSpaces, finalTag);
                                                                            auxnewInitialTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);

                                                                            asprintf(&$$, "%s %s>", auxnewInitialTag, $2);
                                                                        }   
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

AttributeHandler    :   '(' Attributes ')'                              { asprintf(&$$, "%s", $2); }
                    ;

Attributes          :   contentAttributes                               { asprintf(&$$, "%s", $1); }
                    ;

%%

int main() {

    // Initializate Linked List of all Tags
    listTags = init();

    yyparse();

    //printf("\n");
    //printTags(listTags);

    return 0;
}

int yyerror() {
    
    printf("Erro Sintático ou Léxico na linha: %d com o texto: %s\n", yylineno, yytext);
    return 0;
}