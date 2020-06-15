%{
    #include <stdio.h>
    #include <string.h>
    extern int yylex();
    extern int yylineno;
    int yyerror();

%}

%union {
    char *stringValue;
}

%type <stringValue>

FicheiroPug     :   DECLINICIAL HEAD ConteudoHead BODY ConteudoBody
                ;
        
ConteudoHead    :
                ;

ConteudoBody    :
                ;

%%

int main() {
    yyparse();

    return 0;
}

int yyerror() {
    printf("Erro Sintático ou Léxico na linha: %d\n", yylineno);

    return 0;
}