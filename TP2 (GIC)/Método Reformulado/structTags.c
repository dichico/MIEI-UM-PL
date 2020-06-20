#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "structTags.h"

// Print all Tags into the Linked List
void printTags(Tags *listTags)
{

    while (listTags)
    {

        printf("Tag Name: %s\n", listTags->name);
        printf("Number Spaces: %i\n", listTags->numberSpaces);

        listTags = listTags->next;
    }
}

// Linked List Initialization Function
Tags *init()
{

    Tags *listTags = malloc(sizeof(struct tags));
    listTags = NULL;

    return listTags;
}

Tags *removeTags(Tags *listTags, int spaces)
{
    Tags *newList = malloc(sizeof(struct tags));

    while (listTags && spaces <= listTags->numberSpaces)
    {
        listTags = listTags->next;
    }

    newList = listTags;

    return newList;
}

// Insert New Tag into the Linked List
Tags *insertTag(Tags *listTags, int spaces, char *nameTag)
{
    Tags *newList = malloc(sizeof(struct tags));

    // Empty Linked List
    if (listTags == NULL)
    {
        newList->numberSpaces = spaces;
        newList->name = nameTag;
        newList->next = NULL;
    }
    // Otherwise
    else
    {
        listTags = removeTags(listTags, spaces);

        newList->numberSpaces = spaces;
        newList->name = nameTag;
        newList->next = listTags;
    }

    listTags = newList;

    return listTags;
}

char *initialTagClose(Tags *listTags, char *tag, int spaces)
{
    char *tagFinal;

    if (spaces < listTags->numberSpaces)
    {

        tagFinal = strdup(listTags->name);
        listTags = listTags->next;

        while (listTags && spaces <= listTags->numberSpaces)
        {
            strcat(tagFinal, "\n");
            strcat(tagFinal, listTags->name);
            listTags = listTags->next;
        }

        strcat(tagFinal, "\n");
        strcat(tagFinal, tag);
    }

    return tagFinal;
}

// Print all Tags into the Linked List
// Formated Text
void printFinalTags(Tags *listTags)
{
    printf("\n");

    while (listTags)
    {
        printf("%s\n", listTags->name);
        listTags = listTags->next;
    }
}