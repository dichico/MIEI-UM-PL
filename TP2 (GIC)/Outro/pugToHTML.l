%{
    #include "y.tab.h"
%}

%option yylineno

%%

\n                                  ;

"html"                              return HTML;

\(                                  return *yytext;
\)                                  return *yytext;
\"                                  return *yytext;
\=                                  return *yytext;
\,                                  return *yytext;

[ ]*"head"                          { yylval.stringValue = strdup(yytext); return initialHead; }
[ ]*"title="                        { yylval.stringValue = strdup(yytext); return initialTitle; }
[ ]*"link"                          { yylval.stringValue = strdup(yytext); return initialLink; }
[ ]*"body"                          { yylval.stringValue = strdup(yytext); return initialBody; }
[ ]*"h1"                            { yylval.stringValue = strdup(yytext); return initialHeader; }

[a-zA-Z]+\=\".+\"                   { yylval.stringValue = strdup(yytext); return stringAttribute; }
[\ a-zA-Z0-9]+                        { yylval.stringValue = strdup(yytext); return string; }

%%