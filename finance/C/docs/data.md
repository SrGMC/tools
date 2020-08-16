# data.c

Functions to read and write in-memory data

## Table of Contents

- [data.c](#datac)
  - [Table of Contents](#table-of-contents)
  - [_int_ pushCategory](#int-pushcategory)
    - [Parameters](#parameters)
  - [_int_ pushEmptyCategory](#int-pushemptycategory)
    - [Parameters](#parameters-1)
  - [_int_ removeCategory](#int-removecategory)
    - [Parameters](#parameters-2)
  - [_int_ pushTransaction](#int-pushtransaction)
    - [Parameters](#parameters-3)
  - [_int_ pushEmptyTransaction](#int-pushemptytransaction)
    - [Parameters](#parameters-4)
  - [_int_ removeTransaction](#int-removetransaction)
    - [Parameters](#parameters-5)
  - [_int_ getCategoryByName](#int-getcategorybyname)
    - [Parameters](#parameters-6)
  - [_void_ computeCurrent](#void-computecurrent)
    - [Parameters](#parameters-7)
  - [_void_ computeEstimated](#void-computeestimated)
    - [Parameters](#parameters-8)

* * *

## _int_ pushCategory

Creates a new category into the categories array with the specified values

### Parameters

-   `char *name`  String containing the name of the category
-   `float budget`  Budget allocated to the category

Returns **int** index/ID of the category, -1 in case of error

## _int_ pushEmptyCategory

Creates a new empty category into the categories array

### Parameters

Returns **int** index/ID of the category, -1 in case of error

## _int_ removeCategory

Remove a category from the categories array

### Parameters

-   `int id`  index/ID of the category

Returns **void**

## _int_ pushTransaction

Creates a new transaction into the transactiosn array with the specified values.  
Also performs several operations in order to compute current spending, balance, etc.

### Parameters

-   `char *date`  String containing and ISO formatted date, that will be converted into a struct tm
-   `char *name`  String containing the name of the transaction
-   `char *category`  String containing the name of the category
-   `float value`  Value of the transactions

Returns **int** index/ID of the transaction, -1 in case of error

## _int_ pushEmptyTransaction

Creates a new empty transaction into the transactions array

### Parameters

Returns **int** index/ID of the transaction, -1 in case of error

## _int_ removeTransaction

Remove a transaction from the transactions array

### Parameters

-   `int id`  index/ID of thetransaction

Returns **void**

## _int_ getCategoryByName

Find the ID of a category by name

### Parameters

-   `char *string`  String containing the name of the category

Returns **int** index/ID of the category, -1 if not found

## _void_ computeCurrent

Recomputes values for spending, limit and balance as well as each category current spending.

### Parameters

Returns **void**

## _void_ computeEstimated

Recomputes estimated value. This is done by computing the number of months between the current day and the estimated view day, and adding the limit and the income to the balance

### Parameters

Returns **void**