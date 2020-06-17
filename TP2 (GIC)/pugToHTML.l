%{
    #include "y.tab.h"
%}

%option yylineno

%%

\n                      ;

"html"                  return HTML;
"head"                  return HEAD;
"title="[ ]*            return TITLE;
"link"                  return LINK;
"body"                  return BODY;

\(                      return *yytext;
\)                      return *yytext;
\"                      return *yytext;
\=                      return *yytext;
\,                      return *yytext;

^[ ]*                   { yylval.stringValue = strdup(yytext); return initialSpaces; }
\"(.*?)\"               { yylval.stringValue = strdup(yytext); return stringAttribute; }
[a-zA-Z0-9]+            { yylval.stringValue = strdup(yytext); return string; }
