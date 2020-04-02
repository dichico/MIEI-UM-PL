#define isFile 1
#define isDirectory 0

typedef struct directories {

    int lineNumber; // Ir ao último (lineNumber-1)
    int fileOrDirectory;
    char* name;
    char* directory;
    struct directories* next;

} Directories;

int countLines(char *lineName);
char* removeLines(char *name, char *rootName);
Directories* init();
char* getDirectory(Directories *list, char* nameFile);
Directories* insertEnd(Directories *list, int lN, int fD, char *n, char *d);
void createDirectory(Directories *list);
void createFile(Directories *list);
Directories* insertDirectory(Directories* list, int fD, char *fileName, char *rootName);
char* lastDirectory(Directories *list);
void printDirectories(Directories *list);