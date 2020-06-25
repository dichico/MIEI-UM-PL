%{
    #include "y.tab.h"

    char *pipedText = "";
    char *spacesPipedText;
%}

%option yylineno

%x CONTENTTAG CONTENTPIPEDTAG PIPEDTEXT

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
[a-zA-Z0-9]+\=\".+\"/[\)|\,]        { yylval.stringValue = strdup(yytext); return contentAttributes; }
\n[ ]+/\|                           {  pipedText = malloc(sizeof(char*)); BEGIN CONTENTPIPEDTAG; }

<CONTENTTAG>{
    [ ]+\"                          ;
    [^\"]*                          { yylval.stringValue = strdup(yytext); return contentTag; }
    .                               BEGIN INITIAL;
}

<CONTENTPIPEDTAG>{
    \|[ ]+                          { BEGIN PIPEDTEXT; }
    \n[ ]+\|/[ ]+                   { BEGIN PIPEDTEXT; }
} 

<PIPEDTEXT>{
    [^\ ].*/\n[ ]+\|                { 
                                        strcat(pipedText, " "); 
                                        strcat(pipedText, yytext); 
                                        BEGIN CONTENTPIPEDTAG; 
                                    }                            
    [^\ ].*                         { 
                                        strcat(pipedText, " "); 
                                        strcat(pipedText, yytext);  
                                        
                                        yylval.stringValue = strdup(pipedText); 
                                        
                                        BEGIN INITIAL; 
                                        return contentPipedTag; 
                                    }
}

%%