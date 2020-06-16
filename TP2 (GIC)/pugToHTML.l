%{
    #include "y.tab.h"
%}

%option yylineno

%%

"html"                  return HTML;
[ ]+"title="[ ]*        return TITLE;

\(                      return *yytext;
\)                      return *yytext;
\"                      return *yytext;

[\ a-zA-Z]+               {  yylval.stringValue = strdup(yytext); return string; }
