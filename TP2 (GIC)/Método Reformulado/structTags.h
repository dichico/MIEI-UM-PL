typedef struct tags
{

    char *name;
    int numberSpaces;
    struct tags *next;

} Tags;

Tags *init();
Tags *removeTags(Tags *listTags, int spaces);
Tags *insertTag(Tags *listTags, int spaces, char *nameTag);
void printFinalTags(Tags *listTags);
char *initialTagClose(Tags *listTags, char *tag, int spaces);
void printTags(Tags *listTags);