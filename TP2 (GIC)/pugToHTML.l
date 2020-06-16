%{
    #include "y.tab.h"
%}

%option yylineno

%%

\n                      ;

"html"                  return HTML;
[ ]+"title="[ ]*        { yylval.stringValue = strdup(yytext); return TITLE; }

\(                      return *yytext;
\)                      return *yytext;
\"                      return *yytext;
\=                      return *yytext;

[\ a-zA-Z]+             { yylval.stringValue = strdup(yytext); return string; }
