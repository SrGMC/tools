// Finance
// A terminal-based finance manager
//
// print.c
// CLI printing utilities
//
// Author: Álvaro Galisteo (https://alvaro.ga)
// Copyright 2020 - GPLv3

#include "print.h"
#include "shared.h"

/*******************************************************************************
 * Print app header
 *
 * @param subtitle String storing the subtitle
 ******************************************************************************/
void printHeader(char *subtitle) {
  system("clear");
  printf("\e[1m%s\e[0m\n", NAME);
  printf("%s\n\n", subtitle);
  printf("Balance:                   € %.2f\n", balance);
  printf("Spending @ %s:            € %.2f\n", months[viewTime.tm_mon],
         spending);
  printf("Limit:                     € %.2f\n", limit);
  printf("Estimated balance @ %s:   € %.2f\n", months[estimatedTime.tm_mon],
         estimated);
  printf("\n");
}

/*******************************************************************************
 * Print all categories into screen
 ******************************************************************************/
void printCategories() {
  int padding = (strlen("Category") - categoryLength);

  printf("ID     Category%-*s    Budget            Current spending\n", padding,
         " ");

  for (int i = 0; i < categoryCount; ++i) {
    padding = (strlen(categories[i].name) - categoryLength);

    printf("%-*d \033[0;3%dm%s\033[0m%-*s    € %-*.2f    € %.2f\n", 6, i + 1,
           get_color(categories[i].name), categories[i].name, padding, " ", 12,
           categories[i].budget, categories[i].current);
  }
}

/*******************************************************************************
 * Print all transactions into screen
 ******************************************************************************/
void printTransactions() {
  printHeader("Transaction list");
  int paddingN = (strlen("Transaction") - transactionLength);
  int paddingC = (strlen("Category") - categoryLength);

  printf("ID     Date           Transaction%-*s    Category%-*s    Value\n",
         paddingN, " ", paddingC, " ");

  for (int i = 0; i < transactionCount; ++i) {
    paddingN = (strlen(transactions[i].name) - transactionLength);
    paddingC = (strlen(transactions[i].category) - categoryLength);

    printf("%-*d %d-%02d-%02d     %s%-*s    \033[0;3%dm%s\033[0m%-*s    € "
           "%.2f\n",
           6, i + 1, 1900 + transactions[i].date.tm_year,
           transactions[i].date.tm_mon + 1, transactions[i].date.tm_mday,
           transactions[i].name, paddingN, " ",
           get_color(transactions[i].category), transactions[i].category,
           paddingC, " ", transactions[i].value);
  }
}

/*******************************************************************************
 * Print all transactions between a range
 ******************************************************************************/
void printTransactionsRange(int sy, int sm, int sd, int ey, int em, int ed) {
  printHeader("Transaction list");
  int paddingN = (strlen("Transaction") - transactionLength);
  int paddingC = (strlen("Category") - categoryLength);

  printf("ID     Date           Transaction%-*s    Category%-*s    Value\n",
         paddingN, " ", paddingC, " ");

  for (int i = 0; i < transactionCount; ++i) {
    /* If date is after start and before end, display category */
    if (timeCompareDay(sy, transactions[i].date.tm_year, sm,
                       transactions[i].date.tm_mon, sd,
                       transactions[i].date.tm_mday) &&
        timeCompareDay(transactions[i].date.tm_year, ey,
                       transactions[i].date.tm_mon, em,
                       transactions[i].date.tm_mday, ed)) {
      paddingN = (strlen(transactions[i].name) - transactionLength);
      paddingC = (strlen(transactions[i].category) - categoryLength);

      printf("%-*d %d-%02d-%02d     %s%-*s    \033[0;3%dm%s\033[0m%-*s    € "
             "%.2f\n",
             6, i + 1, 1900 + transactions[i].date.tm_year,
             transactions[i].date.tm_mon + 1, transactions[i].date.tm_mday,
             transactions[i].name, paddingN, " ",
             get_color(transactions[i].category), transactions[i].category,
             paddingC, " ", transactions[i].value);
    }
  }
}

/*******************************************************************************
 * Print a menu selection screen
 *
 * @param op Menu view to print
 ******************************************************************************/
void printMenu(int op) {
  printf("\n");
  if (op == CATEGORY) {
    printf("1) Add category\n");
    printf("2) Remove category\n");
    printf("0) \033[0;31mBack\033[0m\n");
  } else if (op == TRANSACTION) {
    printf("1) Add spending\n");
    printf("2) Add income\n");
    printf("3) Remove transaction\n");
    printf("0) \033[0;31mBack\033[0m\n");
  } else if (op == VIEW) {
    printf("1) Change display month\n");
    printf("2) Change estimated month\n");
    printf("0) \033[0;31mBack\033[0m\n");
  } else if (op == DISPLAY) {
    printf("1) Full list\n");
    printf("2) Current display month\n");
    // printf("3) Custom range\n");
    // printf("4) By category\n");
    printf("0) \033[0;31mBack\033[0m\n");
  } else {
    printf("1) View transactions\n");
    printf("2) View\n");
    printf("3) Category\n");
    printf("4) Transactions\n");
    printf("0) \033[0;31mExit\033[0m\n");
  }
  printf("Select an option: ");
}
