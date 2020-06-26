%{
    #include "y.tab.h"

    char *pipedText = "";
    char *spacesPipedText;
%}

%option yylineno

%x CONTENTTAG CONTENTATTRIBUTE ATTRIBUTETEXT CONTENTPIPEDTAG PIPEDTEXT

%%

[ ]                                 ;
\n                                  return *yytext;
\(                                  return *yytext;
\)                                  return *yytext;
\/                                  return *yytext;
\'                                  return *yytext;
\,                                  return *yytext;
\=                                  { BEGIN CONTENTTAG; return *yytext; }

^[ ]*[a-zA-Z0-9]+                   { yylval.stringValue = strdup(yytext); return beginTag; }
[ ][^\ ].*                          { yylval.stringValue = strdup(yytext); return contentTag; }
[ ]*[a-zA-Z]+\=/[\'|\"]             { yylval.stringValue = strdup(yytext); BEGIN CONTENTATTRIBUTE; return nameAttribute; }
\n[ ]+/\|                           { pipedText = malloc(sizeof(char*)); BEGIN CONTENTPIPEDTAG; }

<CONTENTATTRIBUTE>{
    \'                              { BEGIN ATTRIBUTETEXT; }
    \"                              { BEGIN ATTRIBUTETEXT; }
    \,[ ]+|[ ]+                     { BEGIN INITIAL; }
}

<ATTRIBUTETEXT>{
    [^\'\"]*[\'|\"]/\)              { yytext[strlen(yytext)-1]='\0'; yylval.stringValue = strdup(yytext); BEGIN INITIAL; return valueAttribute; }
    [^\'\"]*[\'|\"]/\,              { yytext[strlen(yytext)-1]='\0'; yylval.stringValue = strdup(yytext); BEGIN CONTENTATTRIBUTE; return valueAttribute; }
    [^\'\"]*[\'|\"]/[ ]+            { yytext[strlen(yytext)-1]='\0'; yylval.stringValue = strdup(yytext); BEGIN CONTENTATTRIBUTE; return valueAttribute; }
}

<CONTENTTAG>{
    [ ]+\'                          ;
    [^\']*                          { yylval.stringValue = strdup(yytext); return contentTag; }
    .                               BEGIN INITIAL;
}

<CONTENTPIPEDTAG>{
    \|[ ]+                          { BEGIN PIPEDTEXT; }
    \n[ ]+\|/[ ]+                   { BEGIN PIPEDTEXT; }
} 

<PIPEDTEXT>{
    [^\ ].*/\n[ ]+\|                { 
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