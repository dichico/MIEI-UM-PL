#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "structTags.h"

// Linked List Initialization Function
Tags *init()
{

    Tags *listTags = malloc(sizeof(struct tags));
    listTags = NULL;

    return listTags;
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
        newList->numberSpaces = spaces;
        newList->name = nameTag;
        newList->next = listTags;
    }

    listTags = newList;

    return listTags;
}

Tags *removeLastTag(Tags *listTags, int numberSpaces)
{

    if (listTags->next == NULL)
    {
        return listTags;
    }
    else
    {
        Tags *firstElement = listTags;
        Tags *newList = listTags->next;

        if (numberSpaces < newList->numberSpaces)
        {
            newList = newList->next;

            while (newList && numberSpaces <= newList->numberSpaces)
            {
                newList = newList->next;
            }

            firstElement->next = newList;
            listTags = firstElement;

            return firstElement;
        }
        else
        {
            return listTags;
        }
    }
}

char *newInitialTag(Tags *listTags, char *initialTag, int numberSpaces)
{
    char *newTag;

    if (listTags->next == NULL)
    {
        return initialTag;
    }
    else
    {
        Tags *newList = listTags->next;

        if (numberSpaces < newList->numberSpaces)
        {
            newTag = strdup(newList->name);

            newList = newList->next;

            while (newList && numberSpaces <= newList->numberSpaces)
            {
                strcat(newTag, "\n");
                strcat(newTag, strdup(newList->name));
                newList = newList->next;
            }

            strcat(newTag, "\n");
            strcat(newTag, strdup(initialTag));

            return newTag;
        }
        else
        {
            return initialTag;
        }
    }
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