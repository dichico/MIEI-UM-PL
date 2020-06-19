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

^[ ]*[a-zA-Z0-9]+\/                 { yylval.stringValue = strdup(yytext); return beginTagSelfClosing; }
^[ ]*[a-zA-Z0-9]+                   { yylval.stringValue = strdup(yytext); return beginTagAttribute; }
^[ ]*[a-zA-Z0-9]+[ ]+               { yylval.stringValue = strdup(yytext); return beginTagDefault; }

[a-zA-Z0-9\ ]+                      { yylval.stringValue = strdup(yytext); return contentTag; }
[a-zA-Z]*\=*\".+\"                  { yylval.stringValue = strdup(yytext); return contentAttribute; }


%%