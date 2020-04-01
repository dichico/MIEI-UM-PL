#define isFile 1
#define isDirectory 0

typedef struct directories {

    int lineNumber; // Ir ao último (lineNumber-1)
    int fileOrDirectory;
    char *name;
    struct directories *next;

} Directories;

int countLines(char *lineName);
Directories* init();
Directories* insertDirectory(Directories* list, int fD, char *fileName);
void printDirectories(Directories *list);