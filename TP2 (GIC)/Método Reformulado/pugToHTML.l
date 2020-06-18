%{
    #include "y.tab.h"
%}

%option yylineno

%x CONTENTTAG

%%

\n                                  ;
\(                                  return *yytext;
\)                                  return *yytext;
\"                                  return *yytext;
\=                                  return *yytext;
\,                                  return *yytext;

^[ ]*[a-zA-Z0-9]+[ ]*               { yylval.stringValue = strdup(yytext); BEGIN CONTENTTAG; return beginTag;}

<CONTENTTAG>{
    .*\n {
        yylval.stringValue = strdup(yytext); 
        return contentTag;
        BEGIN INITIAL;
    }
}

[a-zA-Z]*\=*\".+\"                  { yylval.stringValue = strdup(yytext); return stringAttribute; }

%%