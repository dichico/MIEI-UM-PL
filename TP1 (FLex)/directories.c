#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "directories.h"

int countLines(char *lineName){

    int result = 0;

    while(*lineName && *lineName++ == '-') ++result;

    return result;
}

char *getExtension(char *name, char *name2){
}

char* removeLines(char *name){

    int i, j;

    for(i = 0; name[i] && '-' != name[i]; i++);

    if(name[i]){

        for(j = 1; name[i] = name[i+j];){
            // Remove all '-' and unnecessary spaces.
            if(name[i] == '-' || name[i] == ' ') j++;
            else i++;
        }
    }

    if(name[0] == '{') printf("CERTO");

    return name;
}

Directories* init(){
    
    Directories *list = malloc(sizeof(struct directories));
    list = NULL;

    return list; 
}

Directories* insertEnd(Directories *list, int lN, int fD, char *d){

    Directories *newList = malloc(sizeof(struct directories));
    Directories *current = list;

    while(current -> next != NULL)
        current = current -> next;

    newList -> lineNumber = lN;
    newList -> fileOrDirectory = fD;
    newList -> directory = d;
    newList -> next = NULL;

    current -> next = newList;

    return list;
}

Directories* insertDirectory(Directories *list, int fD, char *name){

    int numberLines = countLines(name);
    char *cleanName = removeLines(name);

    Directories *newList = malloc(sizeof(struct directories));

    // Empty Linked List.
    if(list == NULL) {
        newList -> lineNumber = numberLines;
        newList -> fileOrDirectory = fD;
        newList -> directory = cleanName;
        newList -> next = NULL;
        list = newList;
    }
    // Otherwise.
    else{

        int lineLimit = numberLines - 1;

        if(numberLines == 0) 
            list = insertEnd(list, numberLines, fD, cleanName);

        else{
            Directories *current = list;

            while(current -> next != NULL && (current -> next -> lineNumber) <= lineLimit) 
                current = current -> next;

            char *fullName;
            fullName = strdup(current -> directory);
            strcat(fullName, strdup(cleanName));

            list = insertEnd(list, numberLines, fD, fullName);
        }
    }

    return list;
}

char* lastDirectory(Directories *list){
    
    Directories *current = list;

    while(current -> next != NULL)
        current = current -> next;

    return current -> directory;
}

void printDirectories(Directories *list){

	while(list != NULL){
		printf("Name: %s\n", list -> directory);
        printf("Line Number: %d\n", list -> lineNumber);
		list = list -> next;
	}
}