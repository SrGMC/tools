#define gotoxy(x, y) printf("\033[%d;%dH", (x), (y))

extern void printHeader(char *subtitle);
extern void printCategories();
extern void printTransactions();
extern void printTransactionsRange(int sy, int sm, int sd, int ey, int em,
                                   int ed);
extern void printStart();
extern void printMenu();