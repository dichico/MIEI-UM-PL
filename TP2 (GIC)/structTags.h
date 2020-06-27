typedef struct tags
{

    char *name;
    int numberSpaces;
    struct tags *next;

} Tags;

Tags *init();
Tags *insertTag(Tags *listTags, char *nameTag, int numberSpaces);
Tags *removeLastTag(Tags *listTags, int numberSpaces);
char *newInitialTag(Tags *listTags, char *initialTag, int numberSpaces);
void printFinalTags(Tags *listTags);
void printTags(Tags *listTags);