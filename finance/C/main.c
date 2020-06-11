// Finance
// A terminal-based finance manager
//
// Author: Álvaro Galisteo (https://alvaro.ga)
// Copyright 2020 - GPLv3
//
// Compile with: gcc main.c input.c print.c file.c data.c utils.c shared.h -o
// main

#include "data.h"
#include "file.h"
#include "input.h"
#include "print.h"
#include "shared.h"

int view = ROOT;
char *months[] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};

int categoryCount = 0;
int categoryLength = 0;
int transactionCount = 0;
int transactionLength = 0;

float balance = 0;
float limit = 0;
float spending = 0;
float estimated = 0;

struct tm viewTime;
struct tm estimatedTime;
struct tm currentTime;

Category *categories;
Transaction *transactions;

int action(int view, int choice) {
    if (view != ROOT && !choice) {
        return ROOT;
    }

    if (view == ROOT) {
        switch (choice) {
        case 0:
            writeCategories();
            writeTransactions();
            exit(0);
        case 1:
            printTransactions();

            /* Wait for any keypress before continuing */
            printf("\nPress Enter key to continue...\n");
            getchar();
            break;
        case 2:
            return VIEW;
        case 3:
            return CATEGORY;
        case 4:
            return TRANSACTION;
        }
    } else if (view == VIEW) {
        switch (choice) {
        case 1:
            changeMonth();
            return ROOT;
        case 2:
            changeEstimatedMonth();
            return ROOT;
        }
    } else if (view == CATEGORY) {
        switch (choice) {
        case 1:
            newCategory();
            return ROOT;
        case 2:
            deleteCategory();
            return ROOT;
        }
    } else if (view == TRANSACTION) {
        switch (choice) {
        case 1:
            newTransaction('-');
            return ROOT;
        case 2:
            newTransaction('+');
            return ROOT;
        case 3:
            deleteTransaction();
            return ROOT;
        }
    }

    return view;
}

void menu() {
    int choice = -1;
    do {
        printHeader("Main menu");
        printCategories();
        printMenu(view);
        scanf("%d", &choice);

        view = action(view, choice);

        getchar();
    } while (1);
}

int main(int argc, char **argv) {
    readCategories();
    readTransactions();

    menu();
    return 0;
}