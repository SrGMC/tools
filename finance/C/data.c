// Finance
// A terminal-based finance manager
//
// data.c
// Functions to read and write in-memory data
//
// Author: Álvaro Galisteo (https://alvaro.ga)
// Copyright 2020 - GPLv3

#include "data.h"
#include "shared.h"

/*******************************************************************************
 * Creates a new category into the categories array with the specified values
 *
 * @param name String containing the name of the category
 * @param budget Budget allocated to the category
 *
 * @return index/ID of the category, -1 in case of error
 ******************************************************************************/
int pushCategory(char *name, float budget) {
    int index = pushEmptyCategory();

    /* Assign attributes */
    categories[index].name = name;
    categories[index].budget = budget;
    categories[index].current = 0;

    /* Compute the maximum length, used in displays and storage */
    int length = strlen(categories[index].name) + 1;
    categoryLength = length > categoryLength ? length : categoryLength;

    /* Compute current and estimated */
    computeCurrent();
    computeEstimated();

    return index;
}

/*******************************************************************************
 * Creates a new empty category into the categories array
 *
 * @return index/ID of the category, -1 in case of error
 ******************************************************************************/
int pushEmptyCategory() {
    categoryCount++;
    categories = realloc(categories, categoryCount * sizeof(Category));

    return (categoryCount - 1);
}

/*******************************************************************************
 * Remove a category from the categories array
 *
 * @param id index/ID of the category
 ******************************************************************************/
void removeCategory(int id) {
    for (int i = id; i < categoryCount - 1; ++i) {
        categories[i] = categories[i + 1];
    }

    categoryCount--;
    categories = realloc(categories, categoryCount * sizeof(Category));

    /* Compute current and estimated */
    computeCurrent();
    computeEstimated();
}

/*******************************************************************************
 * Creates a new transaction into the transactiosn array with the specified
 * values
 * Also performs several operations in order to compute current spending,
 * balance, etc.
 *
 * @param date String containing and ISO formatted date, that will be converted
 *             into a struct tm
 * @param name String containing the name of the transaction
 * @param category String containing the name of the category
 * @param value Value of the transactions
 *
 * @return index/ID of the transaction, -1 in case of error
 ******************************************************************************/
int pushTransaction(char *date, char *name, char *category, float value) {
    int index = pushEmptyTransaction();

    /* Assign attributes */
    strptime(date, "%Y-%m-%d", &(transactions[index].date));
    transactions[index].name = name;
    transactions[index].category = category;
    transactions[index].value = value;

    /* Compute the maximum length, used in displays and storage */
    int length = strlen(transactions[index].name) + 1;
    transactionLength = length > transactionLength ? length : transactionLength;

    /* Compute current category value and spending based on viewTime */
    int cat = getCategoryByName(transactions[index].category);
    if (cat == -1) {
        fprintf(stderr, "Invalid category in transaction at line %d\n",
                transactionCount);
        exit(1);
    }

    if (viewTime.tm_year == transactions[index].date.tm_year &&
        viewTime.tm_mon == transactions[index].date.tm_mon) {
        spending +=
            transactions[index].value < 0 ? transactions[index].value : 0;
        categories[cat].current += transactions[index].value;
    }

    /* Compute current and estimated */
    computeCurrent();
    computeEstimated();

    return index;
}

/*******************************************************************************
 * Creates a new empty transaction into the transactions array
 *
 * @return index/ID of the transaction, -1 in case of error
 ******************************************************************************/
int pushEmptyTransaction() {
    transactionCount++;
    transactions =
        realloc(transactions, transactionCount * sizeof(Transaction));

    return (transactionCount - 1);
}

/*******************************************************************************
 * Remove a transaction from the transactions array
 *
 * @param id index/ID of thetransaction
 ******************************************************************************/
void removeTransaction(int id) {
    for (int i = id; i < transactionCount - 1; ++i) {
        transactions[i] = transactions[i + 1];
    }

    transactionCount--;
    transactions =
        realloc(transactions, transactionCount * sizeof(Transaction));

    /* Compute current and estimated */
    computeCurrent();
    computeEstimated();
}

/*******************************************************************************
 * Find the ID of a category by name
 *
 * @param string String containing the name of the category
 *
 * @return index/ID of the category, -1 if not found
 ******************************************************************************/
int getCategoryByName(char *string) {
    for (int i = 0; i < categoryCount; ++i) {
        if (!strcmp(string, categories[i].name)) {
            return i;
        }
    }

    return -1;
}

/*******************************************************************************
 * Recomputes values for spending, limit and balance as well as each category 
 * current spending.
 ******************************************************************************/
void computeCurrent() {

    /* Clear spending, limit and balance */
    spending = 0;
    limit = 0;
    balance = 0;
    
    /* Reset categories.current and limit */
    for (int i = 0; i < categoryCount; ++i) {
        categories[i].current = 0;
        limit += categories[i].budget;
    }
    
    for (int i = 0; i < transactionCount; ++i) {
        /* Recompute balance */
        balance += transactions[i].value;
        
        /* If transaction matches view date, add to spending and 
         * the corresponding category's current' */
        if (viewTime.tm_year == transactions[i].date.tm_year &&
            viewTime.tm_mon == transactions[i].date.tm_mon) {
            spending += transactions[i].value < 0 ? transactions[i].value : 0;
            categories[getCategoryByName(transactions[i].category)].current +=
                transactions[i].value;
        }
    }
}

/*******************************************************************************
 * Recomputes estimated value. This is done by computing the number of months
 * between the current day and the estimated view day, and adding the limit and
 * the income to the balance
 ******************************************************************************/
void computeEstimated() {
    float currentMonth = 0;
    float currentLimit = limit * 1;
    for (int i = 0; i < transactionCount; ++i) {
        /* If transaction matches today's date, add to spending and 
         * the corresponding category's current' */
        if (currentTime.tm_year == transactions[i].date.tm_year &&
            currentTime.tm_mon == transactions[i].date.tm_mon) {
            currentMonth += transactions[i].value;
        }
    }

    // Get current spending
    currentMonth = abs(currentLimit + currentMonth);

    estimated = 0;
    int mDiff = monthDiff(estimatedTime.tm_year, currentTime.tm_year,
                          estimatedTime.tm_mon, currentTime.tm_mon);
    estimated = balance - currentMonth + (mDiff * EST_INCOME) - ((mDiff - 1) * (limit));
}
