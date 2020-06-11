#define gotoxy(x,y) printf("\033[%d;%dH", (x), (y))

extern void printHeader(char *subtitle);
extern void printCategories();
extern void printTransactions();
extern void printStart();
extern void printMenu();