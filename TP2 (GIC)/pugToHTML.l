%{
    #include "y.tab.h"

    char *pipedText;
    char *auxPipedText;
    int sizePipedText;

    char *classDivText;
    char *auxClassDivText;
    int sizeClassDivText;

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
[ ][^\ ].*                          { yylval.stringValue = strdup(yytext); return contentTag; }
[ ]*[a-zA-Z]+\=/[\'|\"]             { yylval.stringValue = strdup(yytext); BEGIN CONTENTATTRIBUTE; return nameAttribute; }
[ ]*\n[ ]+/\|                       { pipedText = (char*) malloc(100); sizePipedText = 100; BEGIN CONTENTPIPEDTAG; }
^[ ]*/\#                            { classDivText = (char*) malloc(100); sizeClassDivText = 100; yylval.stringValue = strdup(yytext); BEGIN CONTENTDIV; return beginDiv; }
^[ ]*/\.                            { classDivText = (char*) malloc(100); sizeClassDivText = 100; yylval.stringValue = strdup(yytext); BEGIN CLASSDIV; return beginDiv; }

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
    [ ]+[\'|\"]                     ;
    [^\'\"]*                        { yylval.stringValue = strdup(yytext); return contentTag; }
    .                               BEGIN INITIAL;
}

<CONTENTPIPEDTAG>{
    \|[ ]+                          { BEGIN PIPEDTEXT; }
    \n[ ]+\|/[ ]+                   { BEGIN PIPEDTEXT; }
} 

<PIPEDTEXT>{
    [^\ ].*/\n[ ]+\|                {
                                        sizePipedText += 100;
                                        auxPipedText = realloc(pipedText, sizePipedText);
                                        
                                        strcat(auxPipedText, yytext);
                                        pipedText = auxPipedText;
                                        BEGIN CONTENTPIPEDTAG; 
                                    }                            
    [^\ ].*                         {
                                        sizePipedText += 100;
                                        auxPipedText = realloc(pipedText, sizePipedText);

                                        strcat(auxPipedText, " "); 
                                        strcat(auxPipedText, yytext);  
                                        pipedText = auxPipedText; 
                                        
                                        yylval.stringValue = strdup(pipedText); 
                                        
                                        BEGIN INITIAL; 
                                        return contentPipedTag; 
                                    }
}

<CONTENTDIV>{
    [\#][^\.]*/\.                   { yylval.stringValue = strdup(yytext+1); BEGIN CLASSDIV; return idDiv; }
    [^\.\n]*                        { yylval.stringValue = strdup(yytext+1); BEGIN INITIAL; return idDiv; }
}

<CLASSDIV>{
    \.[^\.\n]*/\.                   {
                                        sizeClassDivText += 100;
                                        auxClassDivText = realloc(classDivText, sizeClassDivText);

                                        strcat(auxClassDivText, yytext+1);
                                        classDivText = auxClassDivText;

                                        yylval.stringValue = strdup(classDivText);

                                        BEGIN CLASSDIV;  
                                    }
    \.[^\.\n]*                      {
                                        sizeClassDivText += 100;
                                        auxClassDivText = realloc(classDivText, sizeClassDivText);

                                        strcat(auxClassDivText, " "); 
                                        strcat(auxClassDivText, yytext+1);
                                        classDivText = auxClassDivText;

                                        yylval.stringValue = strdup(classDivText);

                                        BEGIN INITIAL; 
                                        return classDiv; 
                                    }
}

%%