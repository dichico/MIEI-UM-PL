#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include "directories.h"

int countLines(char *lineName){

    int result = 0;

    while(*lineName && *lineName++ == '-') ++result;

    return result;
}

char* removeLines(char *name, char *rootName){

    int i, j;

    for(i = 0; name[i] && '-' != name[i]; i++);

    if(name[i]){

        for(j = 1; name[i] = name[i+j];){
            // Remove all '-' and unnecessary spaces.
            if(name[i] == '-' || name[i] == ' ') j++;
            else i++;
        }
    }
    if(rootName != NULL && name[0] == '{'){
        char *endName = strchr(name, '.');
        name = strdup(rootName);
        strcat(name, endName);
    }

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

void createDirectory(Directories *list){
    char *currentDirectory = lastDirectory(list);
    int status = mkdir(currentDirectory, S_IRWXU | S_IRWXG | S_IROTH | S_IXOTH);
}

void createFile(Directories *list){

    char *currentDirectory = lastDirectory(list);
    FILE *newFile = fopen(currentDirectory, "w");
    fclose(newFile);
}

Directories* insertDirectory(Directories *list, int fD, char *name, char *rootName){

    int numberLines = countLines(name);
    char *cleanName = removeLines(name, rootName);

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