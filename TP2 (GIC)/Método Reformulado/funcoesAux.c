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

char *tagWithSpaces(char *text, int initialOrFinal, int isAtributte, int numberSpaces)
{
    char *spaces;
    char *tag;

    if (initialOrFinal == isInitial)
        tag = strdup("<");
    else
        tag = strdup("</");

    if (numberSpaces != 0)
    {
        spaces = strdup(" ");

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
    }
    else
    {
        strcat(tag, text);
    }

    if (!isAtributte)
    {
        strcat(tag, ">");
        return strcat(spaces, tag);
    }
    else if (isAtributte && initialOrFinal == isFinal)
        return strcat(tag, ">");
}