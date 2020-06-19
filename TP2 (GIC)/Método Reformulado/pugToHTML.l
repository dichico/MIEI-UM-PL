%{
    #include "y.tab.h"
%}

%option yylineno

%x CONTENTTAG

%%

\n                                  return *yytext;
\(                                  return *yytext;
\)                                  return *yytext;
\/                                  return *yytext;
\"                                  return *yytext;
\=                                  return *yytext;
\,                                  return *yytext;

^[ ]*[a-zA-Z0-9]+               { yylval.stringValue = strdup(yytext); return beginTag; }

[ ][^\ ].*                      { yylval.stringValue = strdup(yytext); return contentTag; }
[a-zA-Z0-9]*\=*\".+\"           { yylval.stringValue = strdup(yytext); return contentAttribute; }

%%