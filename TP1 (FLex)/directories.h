#define isFile 1
#define isFolder 0

typedef struct directories {

    int lineNumber; // Ir ao último (lineNumber-1)
    int fileOrFolder;
    char* name;
    char* directory;
    struct directories* next;

} Directories;

int countLines(char *lineName);
char* removeLines(char *name, char *rootName);
Directories* init();
int numberIterations(Directories *list, int lineLimit);
char* getDirectory(Directories *list, char* nameFile);
Directories* insertEnd(Directories *list, int lN, int fileFolder, char *n, char *d);
void createDirectory(Directories *list);
void createFile(Directories *list);
Directories* insertDirectory(Directories* list, int fileFolder, char *fileName, char *rootName);
char* lastDirectory(Directories *list);
void printDirectories(Directories *list);