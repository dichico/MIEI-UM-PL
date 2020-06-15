%{
    #include "y.tab.h"
%}

%option yylineno

%%

html\(.*\)              return DECLINICIAL;
[\t]"head"              return HEAD;                   


