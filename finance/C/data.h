extern int pushCategory(char* name, float budget);
extern int pushEmptyCategory();
extern void removeCategory(int id);
extern int pushTransaction(char *date, char* name, char* category, float value);
extern int pushEmptyTransaction();
extern void removeTransaction(int id);
extern int getCategoryByName(char* string);
extern void computeCurrent();
extern void computeEstimated();