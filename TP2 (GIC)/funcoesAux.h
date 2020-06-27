#define isInitial 1
#define isFinal 0

#define defaultTag 2
#define attributeTag 3
#define selfClosingTag 4

int countInitialSpaces(char *text);
char *tagWithSpaces(char *text, int initialOrFinal, int isAtributte, int numberSpaces);