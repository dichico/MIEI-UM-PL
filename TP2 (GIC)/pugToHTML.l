%{
    #include "y.tab.h"

    char *pipedText = "";
    char *classDivText = "";
    char *spacesPipedText;
%}

%option yylineno

%x CONTENTTAG TAGTEXT CONTENTATTRIBUTE ATTRIBUTETEXT CONTENTPIPEDTAG PIPEDTEXT CONTENTDIV CLASSDIV

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
[ ][^\ ].*                          { yylval.stringValue = strdup(yytext+1); return contentTag; }
\n[ ]+/\|                           { pipedText = malloc(sizeof(char*)); BEGIN CONTENTPIPEDTAG; }
^[ ]*\#                             { classDivText = malloc(sizeof(char*)); yylval.stringValue = strdup(yytext); BEGIN CONTENTDIV; }
^[ ]*/\.                            { classDivText = malloc(sizeof(char*)); yylval.stringValue = strdup(yytext); BEGIN CLASSDIV; }
[ ]*[a-zA-Z]+\=/[\'|\"]             { yylval.stringValue = strdup(yytext); BEGIN CONTENTATTRIBUTE; return nameAttribute; }

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
    [ ]+[\'|\"]                     { BEGIN TAGTEXT; }
}

<TAGTEXT>{
    [^\'\"]*                        { yylval.stringValue = strdup(yytext); return contentTag; }
    .                               { BEGIN INITIAL; }
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

<CONTENTDIV>{
    [^\.]*/\.                       { yylval.stringValue = strdup(yytext); BEGIN CLASSDIV; return idDiv; }
    [^\.\n]*                        { yylval.stringValue = strdup(yytext); BEGIN INITIAL; return idDiv; }
}

<CLASSDIV>{
    \.[^\.]*/\.                     { strcat(classDivText, yytext+1); yylval.stringValue = strdup(classDivText); BEGIN CLASSDIV;  }
    \.[^\.\n]*                      { strcat(classDivText, " "); strcat(classDivText, yytext+1); yylval.stringValue = strdup(classDivText); BEGIN INITIAL; return classDiv; }
}

%%