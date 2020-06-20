typedef struct tags
{

    char *name;
    int numberSpaces;
    struct tags *next;

} Tags;

Tags *init();
Tags *insertTag(Tags *listTags, int spaces, char *nameTag);
void printFinalTags(Tags *listTags);
void printTags(Tags *listTags);