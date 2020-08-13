// Finance
// A terminal-based finance manager
//
// shared.h
// Shared headers, imports and global variables
//
// Author: Álvaro Galisteo (https://alvaro.ga)
// Copyright 2020 - GPLv3

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define __USE_XOPEN
#include "utils.h"
#include <time.h>

#define CATEGORIES_FILE "categories.txt"
#define TRANSACTIONS_FILE "transactions.txt"

#define NAME "Finance"
#define EST_INCOME 465.69

extern char *months[];

// Structures
typedef struct category {
    char *name;
    float budget;
    float current;
} Category;

typedef struct transaction {
    struct tm date;
    char *name;
    char *category;
    float value;
} Transaction;

enum OPERATIONS { ROOT, CATEGORY, TRANSACTION, VIEW, DISPLAY };

// Counts and lengths
extern int categoryCount;
extern int categoryLength;
extern int transactionCount;
extern int transactionLength;

extern float balance;
extern float limit;
extern float spending;
extern float estimated;

// Time
extern struct tm currentTime;
extern struct tm viewTime;
extern struct tm estimatedTime;

// Data
extern Category *categories;
extern Transaction *transactions;

// Files
extern FILE *categoriesFp;
extern FILE *transactionsFp;