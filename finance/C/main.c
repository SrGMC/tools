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
#include <time.h>

/* View data */
int view = ROOT;
char *months[] = {"Jan", "Feb", "Mar", "Apr", "May", "Jun",
                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};

/* Category and transaction helper data */
int categoryCount = 0;
int categoryLength = 0;
int transactionCount = 0;
int transactionLength = 0;

/* Info data */
float balance = 0;
float limit = 0;
float spending = 0;
float estimated = 0;

/* Times */
struct tm viewTime;
struct tm estimatedTime;
struct tm currentTime;

/* Arrays */
Category *categories;
Transaction *transactions;

/*******************************************************************************
 * Performs an action. Returns the same view if choice is not one of the
 * defined ones.
 *
 * @param view Current view
 * @param choice Action performed in the view
 *
 * @return view where to switch
 ******************************************************************************/
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
      return DISPLAY;
    case 2:
      return VIEW;
    case 3:
      return CATEGORY;
    case 4:
      return TRANSACTION;
    }
  } else if (view == DISPLAY) {
    switch (choice) {
    case 1:
      printTransactions();

      /* Wait for any keypress before continuing */
      printf("\nPress Enter key to continue...\n");
      getchar();
      return ROOT;
    case 2:
      printTransactionsRange(viewTime.tm_year, viewTime.tm_mon, 1,
                             viewTime.tm_year, viewTime.tm_mon, 31);

      /* Wait for any keypress before continuing */
      printf("\nPress Enter key to continue...\n");
      getchar();
      return ROOT;
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

/*******************************************************************************
 * Displays the current view menu, and waits for an action to execute.
 *
 * finance uses a view-action structure. What menu to display is determined by
 * the view variable, and the action determined by the user's action.
 * If anything else needs to be performed (such as asking for user input), this
 * is performed by action(), and then the display is cleared in order to show
 * the new menu.
 ******************************************************************************/
void menu() {
  int choice = -1;
  do {
    /* Print header then categories */
    printHeader("Main menu");
    printCategories();

    /* Print menu according to the view */
    printMenu(view);

    /* Wait for a choice*/
    scanf("%d", &choice);

    /* Execute an action determined by the current view and the choice
     * and change to the returned view */
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
