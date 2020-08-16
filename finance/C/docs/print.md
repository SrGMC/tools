# print.c

CLI printing utilities

## Table of Contents

- [print.c](#printc)
  - [Table of Contents](#table-of-contents)
  - [_void_ printHeader](#void-printheader)
    - [Parameters](#parameters)
  - [_void_ printCategories](#void-printcategories)
    - [Parameters](#parameters-1)
  - [_void_ printTransactions](#void-printtransactions)
    - [Parameters](#parameters-2)
  - [_void_ printTransactionsRange](#void-printtransactionsrange)
    - [Parameters](#parameters-3)
  - [_void_ printMenu](#void-printmenu)
    - [Parameters](#parameters-4)

* * *

## _void_ printHeader

Print app header

### Parameters

-   `char *subtitle`  String storing the subtitle

Returns **void**

## _void_ printCategories

Print all categories into screen

### Parameters

Returns **void**

## _void_ printTransactions

Print all transactions into screen

### Parameters

Returns **void**

## _void_ printTransactionsRange

Print all transactions between a range

### Parameters

-   `int sy`  Starting year
-   `int sm`  Starting year
-   `int sd`  Starting day-of-month
-   `int ey`  Ending year
-   `int em`  Ending month
-   `int ed`  Ending day-of-month

Returns **void**

## _void_ printMenu

Print a menu selection screen

### Parameters

-   `int op`  Menu view to print

Returns **void**