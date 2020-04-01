
typedef struct niveis {
    // Ir ao último (lineNumber-1)
    int lineNumber;
    int fileOrDirectory;
    char *name;
    struct niveis *next;
} niveis;



0          1                 2               3                     4                  5
0          1                 1               2                     1                  2                     3
1          0                 1               0                     1                  
diogo -->  diogo/diogo.fl --> diogo/doc/ --> diogo/doc/diogo.md -->diogo/exemplo/ --> diogo/exemplo/doc --> 