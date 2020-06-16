%{
    #include "y.tab.h"
%}

%option yylineno

%%

"html"                  return HTML;

\(                      return *yytext;
\)                      return *yytext;

[\ a-zA-Z]+               {  yylval.stringValue = strdup(yytext); return string; }
