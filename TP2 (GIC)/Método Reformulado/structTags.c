#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "structTags.h"

// Linked List Initialization Function
Tags* init() {
    
    Tags *listTags = malloc(sizeof(struct tags));
    listTags = NULL;

    return listTags; 
}

// Insert New Tag into the Linked List
Tags* insertTag(Tags *listTags, int spaces, char *nameTag) {

    Tags *newList = malloc(sizeof(struct tags));
    
    // Empty Linked List
    if(listTags == NULL) {
        newList -> numberSpaces = spaces;
        newList -> name = nameTag;
        newList -> next = NULL;
    }
    // Otherwise
    else {
        newList -> numberSpaces = spaces;
        newList -> name = nameTag;        
        newList -> next = listTags;
    }

    listTags = newList;

    return listTags;
}

// Print all Tags into the Linked List
void printTags(Tags *listTags){

	while(listTags){
		
		printf("Tag Name: %s\n", listTags -> name);
		printf("Number Spaces: %i\n", listTags -> numberSpaces);

		listTags = listTags -> next;
	}
}