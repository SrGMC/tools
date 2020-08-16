# input.c

Utilities to input data to store

## Table of Contents

- [input.c](#inputc)
  - [Table of Contents](#table-of-contents)
  - [_void_ newTransaction](#void-newtransaction)
    - [Parameters](#parameters)
  - [_void_ deleteTransaction](#void-deletetransaction)
    - [Parameters](#parameters-1)
  - [_void_ newCategory](#void-newcategory)
    - [Parameters](#parameters-2)
  - [_void_ deleteCategory](#void-deletecategory)
    - [Parameters](#parameters-3)
  - [_void_ changeMonth](#void-changemonth)
    - [Parameters](#parameters-4)
  - [_void_ changeEstimatedMonth](#void-changeestimatedmonth)
    - [Parameters](#parameters-5)

* * *

## _void_ newTransaction

Asks the user for values and creates a new transaction

### Parameters

-   `char type`  The type of transaction, + or -

Returns **void**

## _void_ deleteTransaction

Asks the user what transaction to delete

### Parameters

Returns **void**

## _void_ newCategory

Asks the user for values and creates a new category

### Parameters

Returns **void**

## _void_ deleteCategory

Asks the user what category to delete

### Parameters

Returns **void**

## _void_ changeMonth

Asks the user for a year and month where to change the current spending view

### Parameters

Returns **void**

## _void_ changeEstimatedMonth

Asks the user for a year and month where to change the estimated balance

### Parameters

Returns **void**