%{
    #include "y.tab.h"
%}

%option yylineno

%%

html\(.*\)              return DECLINICIAL;
"head"                  return HEAD;


