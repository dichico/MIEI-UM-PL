%{
    #include "y.tab.h"

    char *pipedText;
%}

%option yylineno

%x CONTENTTAG CONTENTPIPEDTAG

%%

[ ]                                 ;
\n                                  return *yytext;
\(                                  return *yytext;
\)                                  return *yytext;
\/                                  return *yytext;
\"                                  return *yytext;
\,                                  return *yytext;
\=                                  { BEGIN CONTENTTAG; return *yytext; }
\|                                  { BEGIN CONTENTPIPEDTAG; return *yytext; }

^[ ]*[a-zA-Z0-9]+                   { yylval.stringValue = strdup(yytext); return beginTag; }
[ ][^\ ].*                          { yylval.stringValue = strdup(yytext); return contentTag; }
[a-zA-Z0-9]+\=\".+\"/[\)|\,]        { yylval.stringValue = strdup(yytext); return contentAttributes; }

<CONTENTTAG>{
    [ ]+\"   ;
    [^\"]*  { yylval.stringValue = strdup(yytext); return contentTag; }
    .       BEGIN INITIAL;
}

<CONTENTPIPEDTAG>{
    ^[ ]*\|     BEGIN CONTENTPIPEDTAG;
    [ ].*\n     { yylval.stringValue = strdup(yytext); return contentTag; }
    .           BEGIN INITIAL;
}

%%