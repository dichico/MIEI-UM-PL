#include <stdio.h>
#include <string.h>

#include "funcoesAux.h"

int countInitialSpaces(char *text)
{
    int numberSpaces = 0;

    for (int i = 0; text[i] != '\0'; i++)
    {
        if (text[i] == ' ')
            numberSpaces++;
        else
            return numberSpaces;
    }
}

char *tagWithSpaces(char *text, int initialOrFinal)
{
    char *spaces = strdup(" ");
    char *tag;

    if (initialOrFinal == isInitial)
        tag = strdup("<");
    else
        tag = strdup("</");

    for (int i = 1; text[i] != '\0'; i++)
    {
        if (text[i] == ' ')
            strcat(spaces, strdup(" "));
        else
        {
            strcat(tag, &text[i]);
            break;
        }
    }

    strcat(tag, ">");

    return strcat(spaces, tag);
}