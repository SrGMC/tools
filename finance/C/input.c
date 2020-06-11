// Finance
// A terminal-based finance manager
//
// input.c
// Utilities to input data to store
//
// Author: Álvaro Galisteo (https://alvaro.ga)
// Copyright 2020 - GPLv3

#include "data.h"
#include "file.h"
#include "input.h"
#include "print.h"
#include "shared.h"

/*******************************************************************************
 * Asks the user for values and creates a new transaction
 *
 * @param type The type of transaction, + or -
 ******************************************************************************/
void newTransaction(char type) {
    printHeader("Create a new transaction");

    char temp;

    char date[16];
    char name[256];
    char category[256];
    float value;

    printf("Date (yyyy-mm-dd): ");
    scanf("%s", date);

    printf("Name:              ");
    scanf("%c", &temp);
    scanf("%[^\n]", name);

    if (type == '-') {
        printf("Category:          ");
        scanf("%c", &temp);
        scanf("%[^\n]", category);
    } else {
        strcpy(category, "Income");
    }

    printf("Value:             ");
    scanf("%c", &temp);
    scanf("%f", &value);

    pushTransaction(date, gen_string(name), gen_string(category),
                    type == '-' ? (-1 * value) : value);

    writeTransactions();
    // gotoxy(6, width + 1);
    printf("\nPress Enter key to continue...\n");
    getchar();
}

void deleteTransaction() {
    int choice = -1;
    printHeader("Delete a transaction");
    printTransactions();
    printf("\nEnter the ID of the transaction you wish to delete: ");
    scanf("%d", &choice);
    choice--;

    if (choice <= 0 || choice >= transactionCount) {
        printf("Invalid transaction ID\n");
    } else {
        removeTransaction(choice);
    }

    writeTransactions();
    printf("\nPress Enter key to continue...\n");
    getchar();
}

/*******************************************************************************
 * Asks the user for values and creates a new category
 ******************************************************************************/
void newCategory() {
    printHeader("Create a new category");

    char temp;

    char name[256];
    float budget;

    printf("Name:   ");
    scanf("%c", &temp);
    scanf("%[^\n]", name);

    printf("Budget: ");
    scanf("%c", &temp);
    scanf("%f", &budget);

    pushCategory(gen_string(name), budget);

    writeCategories();
    // gotoxy(6, width + 1);
    printf("\nPress Enter key to continue...\n");
    getchar();
}

void deleteCategory() {
    int choice = -1;
    printHeader("Delete a category");
    printCategories();
    printf("\nEnter the ID of the category you wish to delete: ");
    scanf("%d", &choice);
    choice--;

    if (choice <= 0 || choice >= categoryCount) {
        printf("Invalid category ID\n");
    } else {
        removeCategory(choice);
    }

    writeCategories();
    printf("\nPress Enter key to continue...\n");
    getchar();
}

void changeMonth() {
    printHeader("Change display month");

    char temp;

    int year;
    int month;

    printf("Year (yyyy): ");
    scanf("%c", &temp);
    scanf("%d", &year);
    year -= 1900;

    printf("Month:       ");
    scanf("%c", &temp);
    scanf("%d", &month);
    month--;

    viewTime.tm_year = year;
    viewTime.tm_mon = month;

    computeCurrent();
}

void changeEstimatedMonth() {
    printHeader("Change estimated month");

    char temp;

    int year;
    int month;

    printf("Year (yyyy): ");
    scanf("%c", &temp);
    scanf("%d", &year);
    year -= 1900;

    printf("Month:       ");
    scanf("%c", &temp);
    scanf("%d", &month);
    month--;

    if (!timeCompare(currentTime.tm_year, year, currentTime.tm_mon, month)) {
        printf("Date cannot be before today\n");
        printf("\nPress Enter key to continue...\n");
        getchar();
        return;
    }

    estimatedTime.tm_year = year;
    estimatedTime.tm_mon = month;

    computeEstimated();
}