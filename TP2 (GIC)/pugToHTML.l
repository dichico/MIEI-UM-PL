%{
    #include "y.tab.h"
%}

%option yylineno

%%

"html"                  return HTML;
\n[ ]+"head"            return HEAD;

\(                      return *yytext;
\)                      return *yytext;

[a-zA-Z]+               {  yylval.stringValue = strdup(yytext); return string; }
