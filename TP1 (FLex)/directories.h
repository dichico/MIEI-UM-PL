#define isFile 1
#define isDirectory 0

typedef struct directories {

    int lineNumber; // Ir ao último (lineNumber-1)
    int fileOrDirectory;
    char *directory;
    struct directories *next;

} Directories;

int countLines(char *lineName);
char* removeLines(char *name);
Directories* init();
Directories* insertEnd(Directories *list, int lN, int fD, char *d);
Directories* insertDirectory(Directories* list, int fD, char *fileName);
char* lastDirectory(Directories *list);
void printDirectories(Directories *list);