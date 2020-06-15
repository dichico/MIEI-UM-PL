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

%token HTML HEAD
%token string ERRO

%type <stringValue> string DelcInicial AtributoHandler Atributos Atributo
%type <stringValue> HEAD

%%

FicheiroPug         :   DelcInicial HEAD                     { printf("%s\n<head>", $1); }
                    ;

DelcInicial         :   HTML AtributoHandler                { asprintf(&$$, "<html %s>", $2); }
                    ;


AtributoHandler     :   '(' Atributos ')'                   { asprintf(&$$, "%s", $2); }
                    ;

Atributos           :   Atributos ',' Atributo              { asprintf(&$$, "%s", $3); }
                    |   Atributo                            { asprintf(&$$, "%s", $1); }
                    ;

Atributo            :   string                              { asprintf(&$$, "%s", $1); }
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