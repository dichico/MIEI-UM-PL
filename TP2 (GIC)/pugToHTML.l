%{
    #include "y.tab.h"
%}

%option yylineno

%x HEADERS

%%

\n                                  ;

\(                                  return *yytext;
\)                                  return *yytext;
\"                                  return *yytext;
\=                                  return *yytext;
\,                                  return *yytext;

"html"                              return HTML;
[ ]+"head"                          { yylval.stringValue = strdup(yytext); return initialHead; }
[ ]+"title="[ ]*                    { yylval.stringValue = strdup(yytext); return initialTitle; }
[ ]+"link"                          { yylval.stringValue = strdup(yytext); return initialLink; }
[ ]+"body"                          { yylval.stringValue = strdup(yytext); return initialBody; }
[ ]+"h1"[ ]*                        { yylval.stringValue = strdup(yytext); BEGIN HEADERS; return initialHeader;}

<HEADERS>{
    .* {
        yylval.stringValue = strdup(yytext); 
        return string;
        BEGIN INITIAL;
    }
}

[a-zA-Z]*\=*\".+\"                   {  yylval.stringValue = strdup(yytext); return stringAttribute; }

%%