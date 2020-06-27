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
    char *tagDiv;

    Tags *listTags;
%}

%union {    
    char *stringValue;
}

// Apenas são Tokens os Símbolos Terminais (Variáveis e Não Variáveis)
%token beginTag contentTag contentPipedTag beginDiv idDiv classDiv nameAttribute valueAttribute

%type <stringValue> ContentPugFile
%type <stringValue> Tags Tag TagDefault TagAttribute TagSelfClosing TagPiped TagDiv
%type <stringValue> AttributeHandler Attributes Attribute
%type <stringValue> beginTag contentTag contentPipedTag beginDiv idDiv classDiv nameAttribute valueAttribute

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

Tag                 :   TagDefault                                      { asprintf(&$$, "%s", $1); }
                    |   TagAttribute                                    { asprintf(&$$, "%s", $1); }
                    |   TagSelfClosing                                  { asprintf(&$$, "%s", $1); }
                    |   TagPiped                                        { asprintf(&$$, "%s", $1); }
                    |   TagDiv                                          { asprintf(&$$, "%s", $1); }
                    ;

TagDefault          :   beginTag                                        { 
                                                                            if(isAutoSelfClosing($1) == 1){
                                                                                numberSpaces = countInitialSpaces($1);
                                                                                initialTag = tagWithSpaces($1, 1, 4, numberSpaces);
                                                                                
                                                                                initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                                listTags = removeLastTag(listTags, numberSpaces);
                                                                                
                                                                                asprintf(&$$, "%s", initialTagWithClosesTag); 
                                                                            }
                                                                            else{
                                                                                numberSpaces = countInitialSpaces($1);
                                                                                initialTag = tagWithSpaces($1, 1, 2, numberSpaces);
                                                                                finalTag = tagWithSpaces($1, 0, 2, numberSpaces);
                                                                                
                                                                                listTags = insertTag(listTags, finalTag, numberSpaces);
                                                                                initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                                listTags = removeLastTag(listTags, numberSpaces);

                                                                                asprintf(&$$, "%s", initialTagWithClosesTag);
                                                                            }
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
                                                                            if(isAutoSelfClosing($1) == 1){
                                                                                numberSpaces = countInitialSpaces($1);
                                                                                initialTag = tagWithSpaces($1, 1, 3, numberSpaces);
                                                                                
                                                                                initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                                listTags = removeLastTag(listTags, numberSpaces);
                                                                                
                                                                                asprintf(&$$, "%s %s />", initialTagWithClosesTag, $2); 
                                                                            }
                                                                            else{ 
                                                                                numberSpaces = countInitialSpaces($1);
                                                                                initialTag = tagWithSpaces($1, 1, 3, numberSpaces);
                                                                                finalTag = tagWithSpaces($1, 0, 3, numberSpaces);
                                                                                
                                                                                listTags = insertTag(listTags, finalTag, numberSpaces);
                                                                                initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                                listTags = removeLastTag(listTags, numberSpaces);

                                                                                asprintf(&$$, "%s %s>", initialTagWithClosesTag, $2);
                                                                            }
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
                                                                            
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);
                                                                            
                                                                            asprintf(&$$, "%s", initialTagWithClosesTag); 
                                                                        }
                    |   beginTag '/' contentTag                         {
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 4, numberSpaces);
                                                                            
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);
                                                                            
                                                                            asprintf(&$$, "%s%s", initialTagWithClosesTag, $3);                     
                                                                        }
                    |   beginTag '/' '=' contentTag                     { 
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 4, numberSpaces);
                                                                            
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);
                                                                            
                                                                            asprintf(&$$, "%s%s", initialTagWithClosesTag, $4);                         
                                                                        }
                    |   beginTag AttributeHandler '/'                   {
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 3, numberSpaces);
                                                                            
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);
                                                                            
                                                                            asprintf(&$$, "%s %s />", initialTagWithClosesTag, $2); 
                                                                        }
                    |   beginTag AttributeHandler '/' contentTag        {
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 3, numberSpaces);
                                                                            
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);
                                                                            
                                                                            asprintf(&$$, "%s %s />%s", initialTagWithClosesTag, $2, $4); 
                                                                        }
                    |   beginTag AttributeHandler '/' '=' contentTag    {
                                                                            numberSpaces = countInitialSpaces($1);
                                                                            initialTag = tagWithSpaces($1, 1, 3, numberSpaces);
                                                                            
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);
                                                                            
                                                                            asprintf(&$$, "%s %s />%s", initialTagWithClosesTag, $2, $5); 
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

TagDiv              : beginDiv idDiv classDiv                           {
                                                                            tagDiv = strdup($1);
                                                                            strcat(tagDiv, "div");

                                                                            numberSpaces = countInitialSpaces(tagDiv);
                                                                            initialTag = tagWithSpaces(tagDiv, 1, 3, numberSpaces);
                                                                            finalTag = tagWithSpaces(tagDiv, 0, 3, numberSpaces);
                                                                            
                                                                            listTags = insertTag(listTags, finalTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);

                                                                            asprintf(&$$, "%s id=\"%s\" class=\"%s\">", initialTagWithClosesTag, $2, $3);                                                                            
                                                                        }
                    |   beginDiv idDiv                                  { 
                                                                            tagDiv = strdup($1);
                                                                            strcat(tagDiv, "div");

                                                                            numberSpaces = countInitialSpaces(tagDiv);
                                                                            initialTag = tagWithSpaces(tagDiv, 1, 3, numberSpaces);
                                                                            finalTag = tagWithSpaces(tagDiv, 0, 3, numberSpaces);
                                                                            
                                                                            listTags = insertTag(listTags, finalTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);

                                                                            asprintf(&$$, "%s id=\"%s\">", initialTagWithClosesTag, $2);                                                                           
                                                                        }
                    |   beginDiv classDiv                               {
                                                                            tagDiv = strdup($1);
                                                                            strcat(tagDiv, "div");

                                                                            numberSpaces = countInitialSpaces(tagDiv);
                                                                            initialTag = tagWithSpaces(tagDiv, 1, 3, numberSpaces);
                                                                            finalTag = tagWithSpaces(tagDiv, 0, 3, numberSpaces);
                                                                            
                                                                            listTags = insertTag(listTags, finalTag, numberSpaces);
                                                                            initialTagWithClosesTag = newInitialTag(listTags, initialTag, numberSpaces);
                                                                            listTags = removeLastTag(listTags, numberSpaces);

                                                                            asprintf(&$$, "%s class=\"%s\">", initialTagWithClosesTag, $2);
                                                                        }


AttributeHandler    :   '(' Attributes ')'                              { asprintf(&$$, "%s", $2); }
                    ;

Attributes          :   Attributes Attribute                            { asprintf(&$$, "%s %s", $1, $2); }
                    |   Attributes Attribute                            { asprintf(&$$, "%s %s", $1, $2); }
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