%{
    #include "y.tab.h"
%}

%option yylineno

%x CONTENTTAG

%%

\n                                  ;
\(                                  return *yytext;
\)                                  return *yytext;
\/                                  return *yytext;
\"                                  return *yytext;
\=                                  return *yytext;
\,                                  return *yytext;

^[ ]*[a-zA-Z0-9]+                   { yylval.stringValue = strdup(yytext); return beginTagAttribute;}
[a-zA-Z]*\=*\".+\"                  { yylval.stringValue = strdup(yytext); return contentAttribute; }

^[ ]*[a-zA-Z0-9]+\/                 { yylval.stringValue = strdup(yytext); BEGIN CONTENTTAG; return beginTagSelfClosing;}

<CONTENTTAG>{
    .*\n {
        yylval.stringValue = strdup(yytext); 
        return contentTag;
        BEGIN INITIAL;
    }
}


%%