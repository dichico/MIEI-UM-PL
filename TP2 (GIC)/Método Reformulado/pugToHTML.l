%{
    #include "y.tab.h"
%}

%option yylineno

%x CONTENTTAG

%%

[ ]                                 ;
\n                                  return *yytext;
\(                                  return *yytext;
\)                                  return *yytext;
\/                                  return *yytext;
\"                                  return *yytext;
\,                                  return *yytext;
\=                                  { BEGIN CONTENTTAG; return *yytext; }

^[ ]*[a-zA-Z0-9]+                   { yylval.stringValue = strdup(yytext); return beginTag; }
[ ][^\ ].*                          { yylval.stringValue = strdup(yytext); return contentTag; }
[a-zA-Z0-9]+\=\".+\"/\)             { yylval.stringValue = strdup(yytext); return contentAttributes; }

<CONTENTTAG>{
    [ ]+\"   ;
    [^\"]*  { yylval.stringValue = strdup(yytext); return contentTag; }
    .       BEGIN INITIAL;
}

%%