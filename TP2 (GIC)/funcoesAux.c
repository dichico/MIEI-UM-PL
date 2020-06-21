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

char *tagWithSpaces(char *text, int initialOrFinal, int isAttribute, int numberSpaces)
{
    char *tag;
    char *spaces;

    if (initialOrFinal == isInitial)
        tag = strdup("<");
    else
        tag = strdup("</");

    // At least One Space
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

                if (!isAttribute || (isAttribute && initialOrFinal == isFinal))
                {
                    strcat(tag, ">");
                    return strcat(spaces, tag);
                }
                else
                {
                    return strcat(spaces, tag);
                }
            }
        }
    }
    // Zero Spaces
    else
    {
        if (!isAttribute || (isAttribute && initialOrFinal == isFinal))
        {
            strcat(tag, text);
            strcat(tag, ">");
            return tag;
        }
        else
        {
            strcat(tag, text);
            return tag;
        }
    }
}