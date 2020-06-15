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

%token DECLINICIAL HEAD BODY
%token string ERRO

%type <stringValue> string Titulo Scripts ConteudoBody

%%

FicheiroPug     :   DECLINICIAL HEAD ConteudoHead BODY ConteudoBody
                ;
        
ConteudoHead    :   Titulo
                |   Titulo Scripts
                ;

Titulo          :   string
                ;

Scripts         :   string
                ;

ConteudoBody    :   string
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