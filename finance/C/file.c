// Finance
// A terminal-based finance manager
//
// file.c
// Functions to read and write from files
//
// Author: Álvaro Galisteo (https://alvaro.galisteo.me)
// Copyright 2020 - GPLv3

#include "file.h"
#include "data.h"
#include "shared.h"

FILE *categoriesFp;
FILE *transactionsFp;

/*******************************************************************************
 * Read categories from CATEGORIES_FILE and import them into categories array.
 ******************************************************************************/
void readCategories() {
  char *line = NULL;
  size_t len = 0;
  ssize_t read;

  /* Open file */
  categoriesFp = fopen(CATEGORIES_FILE, "r");
  if (categoriesFp == NULL) {
    fprintf(stderr, "Could not open categories.txt\n");
    exit(1);
  }

  /* Read every line, creating a new empty category for every time */
  while ((read = getline(&line, &len, categoriesFp)) != -1) {
    int i = 0;
    char *token = strtok(line, ",");

    /* Attributes */
    char *name;
    float budget;

    /* Once set to split line by comma (,), read every token */
    while (token != NULL) {
      trim(token);

      switch (i) {
      case 0:
        name = gen_string(token);
        break;
      case 1:
        budget = atof(token);
        break;
      default:
        fprintf(stderr, "Invalid category entry entry at line %d\n",
                categoryCount);
        exit(1);
      }

      token = strtok(NULL, ",");
      i++;
    }

    /* Add new category */
    pushCategory(name, budget);
  }

  fclose(categoriesFp);
}

/*******************************************************************************
 * Write data to CATEGORIES_FILE from categories array.
 ******************************************************************************/
void writeCategories() {
  categoriesFp = fopen(CATEGORIES_FILE, "w");

  for (int i = 0; i < categoryCount; ++i) {
    int padding = (strlen(categories[i].name) - categoryLength);
    fprintf(categoriesFp, "%s%-*s    %.2f\n", categories[i].name, padding, ",",
            categories[i].budget);
  }

  fclose(categoriesFp);
}

/*******************************************************************************
 * Read transactions from TRANSACTIONS_FILE and import them into transactions
 * array.
 * Also performs several operations in order to compute current spending, etc.
 ******************************************************************************/
void readTransactions() {
  time_t rawtime;
  struct tm *timeinfo;

  time(&rawtime);
  timeinfo = localtime(&rawtime);

  viewTime.tm_year = timeinfo->tm_year;
  viewTime.tm_mday = timeinfo->tm_mday;
  viewTime.tm_mon = timeinfo->tm_mon;
  estimatedTime.tm_year = timeinfo->tm_year;
  estimatedTime.tm_mday = timeinfo->tm_mday;
  estimatedTime.tm_mon = timeinfo->tm_mon + 1;
  currentTime.tm_year = timeinfo->tm_year;
  currentTime.tm_mday = timeinfo->tm_mday;
  currentTime.tm_mon = timeinfo->tm_mon;

  char *line = NULL;
  size_t len = 0;
  ssize_t read;

  /* Open file */
  transactionsFp = fopen(TRANSACTIONS_FILE, "r");
  if (transactionsFp == NULL) {
    fprintf(stderr, "Could not open transactions.txt\n");
    exit(1);
  }

  /* Read every line, creating a new empty category for every time */
  while ((read = getline(&line, &len, transactionsFp)) != -1) {
    int i = 0;
    char *token = strtok(line, ",");

    /* Attributes */
    char *date;
    char *name;
    char *category;
    float value;

    /* Once set to split line by comma (,), read every token */
    while (token != NULL) {
      trim(token);

      switch (i) {
      case 0:
        date = gen_string(token);
        break;
      case 1:
        name = gen_string(token);
        break;
      case 2:
        category = gen_string(token);
        break;
      case 3:
        value = atof(token);
        break;
      default:
        fprintf(stderr, "Invalid transaction entry at line %d\n",
                transactionCount);
        exit(1);
      }

      token = strtok(NULL, ",");
      i++;
    }

    /* Add new transaction */
    pushTransaction(date, name, category, value);
  }

  fclose(transactionsFp);
}

/*******************************************************************************
 * Write data to TRANSACTIONS_FILE from transactions array.
 ******************************************************************************/
void writeTransactions() {
  transactionsFp = fopen(TRANSACTIONS_FILE, "w");

  for (int i = 0; i < transactionCount; ++i) {
    int paddingN = (strlen(transactions[i].name) - transactionLength);
    int paddingC = (strlen(transactions[i].category) - categoryLength);

    fprintf(transactionsFp, "%d-%02d-%02d,    %s%-*s    %s%-*s    %.2f\n",
            1900 + transactions[i].date.tm_year,
            transactions[i].date.tm_mon + 1, transactions[i].date.tm_mday,
            transactions[i].name, paddingN, ",", transactions[i].category,
            paddingC, ",", transactions[i].value);
  }

  fclose(transactionsFp);
}