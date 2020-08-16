# shared.h

A terminal-based finance manager

## Table of Contents

- [shared.h](#sharedh)
  - [Table of Contents](#table-of-contents)
  - [Externals](#externals)
    - [Counts and lengths](#counts-and-lengths)
    - [Info data](#info-data)
    - [Time](#time)
    - [Data](#data)
    - [Files](#files)
  - [Structures](#structures)
    - [Category (struct category)](#category-struct-category)
      - [Attributes](#attributes)
    - [Transaction (struct transaction)](#transaction-struct-transaction)
      - [Attributes](#attributes-1)
  - [Enumerations](#enumerations)
    - [OPERATIONS](#operations)

* * *

## Externals

### Counts and lengths
- `int categoryCount`
- `int categoryLength`
- `int transactionCount`
- `int transactionLength`

### Info data
- `float balance`
- `float limit`
- `float spending`
- `float estimated`

### Time
- `struct tm viewTime`
- `struct tm estimatedTime`
- `struct tm currentTime`

### Data
- `Category *categories`
- `Transaction *transactions`

### Files
- `FILE *categoriesFp`
- `FILE *transactionsFp`

## Structures

### Category (struct category)

#### Attributes

- `char *name`
- `float budget`
- `float current`

### Transaction (struct transaction)

#### Attributes

- `struct tm date`
- `char *name`
- `char *category`
- `float value`

## Enumerations

### OPERATIONS

0. `ROOT`
1. `CATEGORY`
2. `TRANSACTION`
3. `VIEW`
4. `DISPLAY`