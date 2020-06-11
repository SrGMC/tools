# finance

A simple, easy to use, finance manager.

## Table of contents

- [finance](#bash-launcher)
  - [Features](#features)
  - [Installation](#installation)
    - [Dependencies](#dependencies)
    - [C Version](#c-version)
  - [Usage](#usage)

## Features

This program has the following features:

- [X] Total balance
- [X] View, add and remove categories with limits
- [X] View, add and delete transactions
- [X] Current month's expenditure, divided by categories with the possibility of changing the month to be shown
- [X] Balance forecast to a specific month

While the following ones are in development:

- [ ] Code documentation
- [ ] Display a bar that graphically shows the percentage of category spending
- [ ] Configuration files
- [ ] Webapp

## Installation

### Dependencies

At the time, gcc and make are required in order to compile the C version.

Debian/Ubuntu

```bash
sudo apt-get install gcc make
```

macOS

```bash
brew install gcc make
```

### C version

1. Go to `C` folder
2. Compile using `make`
3. Use with `./main`

## Usage

### Files

Data is currently split in 2 different, comma separated, files: `transactions.txt` and `categories.txt`. When using the program, this files are automattically formated in order to be legible outside the program.

#### Categories

Categories are stored in `categories.txt`. This file contains the category definitions. It follows this line structure: 

```
<category>, <limit>
```

Where:
- `category`: Name of the category
- `limit`: Limit of the category

#### Transactions

Transactions are stored in `transactions.txt`. This file contains all the transactions you want to take into account. It follows this line structure:

```
<date>, <name>, <category>, <value>
```

Where:
- `date`: ISO 8601 date representation. Example: year-month-day, 2020-01-02
- `name`: Name of the transactions. **Be careful** with commas in the name, as they will be treated as other field.
- `category`: Category name defined in `categories.txt`.
- `value`: Value of the transaction, positive for income, negative for spending.

### C Version

Once compiled, run the program with `./main`. Navigate the menus using numbers and the Enter key.

![C version screenshot](screenshot_c.png)
