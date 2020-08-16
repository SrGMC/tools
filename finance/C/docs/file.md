# file.c

Functions to read and write from files

## Table of Contents

- [file.c](#filec)
  - [Table of Contents](#table-of-contents)
  - [Globals](#globals)
  - [_void_ readCategories](#void-readcategories)
    - [Parameters](#parameters)
  - [_void_ writeCategories](#void-writecategories)
    - [Parameters](#parameters-1)
  - [_void_ readTransactions](#void-readtransactions)
    - [Parameters](#parameters-2)
  - [_void_ writeTransactions](#void-writetransactions)
    - [Parameters](#parameters-3)

* * *

## Globals

- `FILE *categoriesFp`
- `FILE *transactionsFp`

## _void_ readCategories

Read categories from CATEGORIES_FILE and import them into categories array.

### Parameters

Returns **void**

## _void_ writeCategories

Write data to CATEGORIES_FILE from categories array.

### Parameters

Returns **void**

## _void_ readTransactions

Read transactions from TRANSACTIONS_FILE and import them into transactions array.  
Also performs several operations in order to compute current spending, etc.

### Parameters

Returns **void**

## _void_ writeTransactions

Write data to TRANSACTIONS_FILE from transactions array.

### Parameters

Returns **void**