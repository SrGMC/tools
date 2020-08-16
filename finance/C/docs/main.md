# main.c

A terminal-based finance manager

## Table of Contents

- [main.c](#mainc)
  - [Table of Contents](#table-of-contents)
  - [Globals](#globals)
    - [View data](#view-data)
    - [Category and transaction helper data](#category-and-transaction-helper-data)
    - [Info data](#info-data)
    - [Times](#times)
    - [Arrays](#arrays)
  - [_int_ action](#int-action)
    - [Parameters](#parameters)
  - [_void_ menu](#void-menu)
    - [Parameters](#parameters-1)
  - [_int_ main](#int-main)
    - [Parameters](#parameters-2)

* * *

## Globals

### View data
- `int view = ROOT`
- `char *months[]`

### Category and transaction helper data
- `int categoryCount`
- `int categoryLength`
- `int transactionCount`
- `int transactionLength`

### Info data
- `float balance`
- `float limit`
- `float spending`
- `float estimated`

### Times
- `struct tm viewTime`
- `struct tm estimatedTime`
- `struct tm currentTime`

### Arrays
- `Category *categories`
- `Transaction *transactions`

## _int_ action

Performs an action. Returns the same view if choice is not one of the defined ones.

### Parameters

-   `int view`  Current view
-   `int choice`  Action performed in the view

Returns **int** view where to switch

## _void_ menu

Displays the current view menu, and waits for an action to execute.

finance uses a view-action structure. What menu to display is determined by the view variable, and the action determined by the user's action.  
If anything else needs to be performed (such as asking for user input), this
is performed by action(), and then the display is cleared in order to show the new menu.

### Parameters

Returns **void**

## _int_ main

### Parameters

-   `int argc`
-   `char **argv`

Returns **int**