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
    char *initialTagWithClosesTag;

    Tags *listTags;
%}

%union {    
    char *stringValue;
}

// Apenas são Tokens os Símbolos Terminais (Variáveis e Não Variáveis)
%token beginTag contentTag contentPipedTag nameAttribute valueAttribute

%type <stringValue> ContentPugFile
%type <stringValue> Tags Tag TagDefault TagAttribute TagSelfClosing TagPiped
%type <stringValue> AttributeHandler Attributes Attribute
%type <stringValue> beginTag contentTag contentPipedTag nameAttribute valueAttribute

%%

FicheiroPug         :   ContentPugFile                                  {
                                                                            printf("%s", $1);
                                                                            printFinalTags(listTags);
                                                                        }
                        ;

ContentPugFile      :   Tags                                            { asprintf(&$$, "%s", $1); }
                    ;

Tags                :   Tag '\n' Tags                                   { asprintf(&$$, "%s\n%s", $1, $3); }
                    |   Tag                                             { asprintf(&$$, "%s", $1); }
                    ;

Tag                 :   TagDefault                                      { asprintf(&$$, "%s", $1); }
                    |   TagAttribute                                    { asprintf(&$$, "%s", $1); }
                    |   TagSelfClosing                                  { asprintf(&$$, "%s", $1); }
                    |   TagPiped                                        { asprintf(&$$, "%s", $1); }
                    ;

TagDefault          :   beginTag                                        { 
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 2, numberSpaces);
                                                                            finalTag = tagWithSpaces($1, 0, 2, numberSpaces);
                                                                            
                                                                            listTags = insertTag(listTags, finalTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);

                                                                            asprintf(&$$, "%s", initialTagWithClosesTag);
                                                                        }   
                    |   beginTag contentTag                             { 
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 2, numberSpaces);
                                                                            finalTag = tagWithSpaces($1, 0, 2, numberSpaces);
                                                                            
                                                                            listTags = insertTag(listTags, finalTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);

                                                                            asprintf(&$$, "%s%s", initialTagWithClosesTag, $2);
                                                                        }
                    |   beginTag '=' contentTag                         {
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 2, numberSpaces);
                                                                            finalTag = tagWithSpaces($1, 0, 2, numberSpaces);
                                                                            
                                                                            listTags = insertTag(listTags, finalTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces); 
                                                                            
                                                                            asprintf(&$$, "%s%s", initialTagWithClosesTag, $3); 
                                                                        }
                    ;

TagAttribute        :   beginTag AttributeHandler                       { 
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 3, numberSpaces);
                                                                            finalTag = tagWithSpaces($1, 0, 3, numberSpaces);
                                                                            
                                                                            listTags = insertTag(listTags, finalTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);

                                                                            asprintf(&$$, "%s %s>", initialTagWithClosesTag, $2);
                                                                        }   
                    |   beginTag AttributeHandler contentTag            { 
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 3, numberSpaces);
                                                                            finalTag = tagWithSpaces($1, 0, 3, numberSpaces);
                                                                            
                                                                            listTags = insertTag(listTags, finalTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);
                                                                            
                                                                            asprintf(&$$, "%s %s>%s", initialTagWithClosesTag, $2, $3); 
                                                                        }
                    |   beginTag AttributeHandler '=' contentTag        { 
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            
                                                                            initialTag = tagWithSpaces($1, 1, 3, numberSpaces);
                                                                            finalTag = tagWithSpaces($1, 0, 3, numberSpaces);
                                                                            
                                                                            listTags = insertTag(listTags, finalTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);

                                                                            asprintf(&$$, "%s %s>%s", initialTagWithClosesTag, $2, $4); 
                                                                        }
                    ;

TagSelfClosing      :   beginTag '/'                                    { 
                                                                            numberSpaces = countInitialSpaces($1);

                                                                            initialTag = tagWithSpaces($1, 1, 4, numberSpaces);

                                                                            listTags = insertTag(listTags, initialTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);

                                                                            // Remove-se depois da Lista dado que não vai ser mais para fechar
                                                                            listTags = removeFirstTag(listTags);

                                                                            asprintf(&$$, "%s", initialTagWithClosesTag); 
                                                                        }
                    |   beginTag '/' contentTag                         {
                                                                            numberSpaces = countInitialSpaces($1);

                                                                            initialTag = tagWithSpaces($1, 1, 4, numberSpaces);
                                                                            printf("Teste %s", initialTag);

                                                                            listTags = insertTag(listTags, initialTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);
                                                                            
                                                                            // Remove-se depois da Lista dado que não vai ser mais para fechar
                                                                            listTags = removeFirstTag(listTags);

                                                                            asprintf(&$$, "%s%s", initialTagWithClosesTag, $3); 
                                                                        }
                    |   beginTag '/' '=' contentTag                     { 
                                                                            numberSpaces = countInitialSpaces($1);

                                                                            initialTag = tagWithSpaces($1, 1, 4, numberSpaces);
                                                                            printf("Teste %s", initialTag);

                                                                            listTags = insertTag(listTags, initialTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);
                                                                            
                                                                            // Remove-se depois da Lista dado que não vai ser mais para fechar
                                                                            listTags = removeFirstTag(listTags);

                                                                            asprintf(&$$, "%s%s", initialTagWithClosesTag, $4); 
                                                                        }
                    |   beginTag AttributeHandler '/'                   { 
                                                                            numberSpaces = countInitialSpaces($1);

                                                                            initialTag = tagWithSpaces($1, 1, 5, numberSpaces);
                                                                            printf("Teste %s", initialTag);

                                                                            listTags = insertTag(listTags, initialTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);
                                                                            
                                                                            // Remove-se depois da Lista dado que não vai ser mais para fechar
                                                                            listTags = removeFirstTag(listTags);

                                                                            asprintf(&$$, "%s %s/>", initialTagWithClosesTag, $2); 
                                                                        }
                    |   beginTag AttributeHandler '/' contentTag        {
                                                                            numberSpaces = countInitialSpaces($1);

                                                                            initialTag = tagWithSpaces($1, 1, 5, numberSpaces);
                                                                            printf("Teste %s", initialTag);

                                                                            listTags = insertTag(listTags, initialTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);
                                                                            
                                                                            // Remove-se depois da Lista dado que não vai ser mais para fechar
                                                                            listTags = removeFirstTag(listTags);

                                                                            asprintf(&$$, "%s %s/>%s", initialTagWithClosesTag, $2, $4);                                                                         }
                    |   beginTag AttributeHandler '/' '=' contentTag    { 
                                                                            numberSpaces = countInitialSpaces($1);

                                                                            initialTag = tagWithSpaces($1, 1, 5, numberSpaces);
                                                                            printf("Teste %s", initialTag);

                                                                            listTags = insertTag(listTags, initialTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);
                                                                            
                                                                            // Remove-se depois da Lista dado que não vai ser mais para fechar
                                                                            listTags = removeFirstTag(listTags);

                                                                            asprintf(&$$, "%s %s/>%s", initialTagWithClosesTag, $2, $5); 
                                                                        }
                    ;

TagPiped            :   beginTag contentPipedTag                        { 
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 2, numberSpaces);
                                                                            finalTag = tagWithSpaces($1, 0, 2, numberSpaces);

                                                                            listTags = insertTag(listTags, finalTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);

                                                                            asprintf(&$$, "%s%s", initialTagWithClosesTag, $2); 
                                                                        }
                    ;

AttributeHandler    :   '(' Attributes ')'                              { asprintf(&$$, "%s", $2); }
                    ;

Attributes          :   Attributes Attribute                            { asprintf(&$$, "%s %s", $1, $2); }
                    |   Attribute                                       { asprintf(&$$, "%s", $1); }   
                    ;

Attribute           :   nameAttribute valueAttribute                    { asprintf(&$$, "%s\"%s\"", $1, $2); }
                    ;


%%

int main() {

    // Initializate Linked List of all Tags
    listTags = init();

    yyparse();

    return 0;
}

int yyerror() {
    
    printf("Erro Sintático ou Léxico na linha: %d com o texto: %s\n", yylineno, yytext);
    return 0;
}