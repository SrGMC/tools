// utils
// C common utilities
//
// Author: Álvaro Galisteo (https://alvaro.galisteo.me)
// Copyright 2020 - GPLv3

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void trim(char *str) {
  int index, i;

  /*
   * Trim leading white spaces
   */
  index = 0;
  while (str[index] == ' ' || str[index] == '\t' || str[index] == '\n') {
    index++;
  }

  /* Shift all trailing characters to its left */
  i = 0;
  while (str[i + index] != '\0') {
    str[i] = str[i + index];
    i++;
  }
  str[i] = '\0'; // Terminate string with NULL

  /*
   * Trim trailing white spaces
   */
  i = 0;
  index = -1;
  while (str[i] != '\0') {
    if (str[i] != ' ' && str[i] != '\t' && str[i] != '\n') {
      index = i;
    }

    i++;
  }

  /* Mark the next character to last non white space character as NULL */
  str[index + 1] = '\0';
}

char *gen_string(char *string) {
  char *p;

  p = malloc(strlen(string) + 1);

  if (p == NULL) {
    fprintf(stderr, "Error while allocating memory\n");
    exit(0);
  }

  strcpy(p, string);

  return p;
}

int get_color(char *string) {
  int l = strlen(string);
  int sum = 0;
  for (int i = 0; i < l; ++i) {
    sum += string[i];
  }

  return sum % 7 + 1;
}

int getLine(char *prmpt, char *buff, int sz) {
  int ch, extra;

  // Get line with buffer overrun protection.
  if (prmpt != NULL) {
    printf("%s", prmpt);
    fflush(stdout);
  }
  if (fgets(buff, sz, stdin) == NULL)
    return -1;

  // If it was too long, there'll be no newline. In that case, we flush
  // to end of line so that excess doesn't affect the next call.
  if (buff[strlen(buff) - 1] != '\n') {
    extra = 0;
    while (((ch = getchar()) != '\n') && (ch != EOF))
      extra = 1;
    return (extra == 1) ? -1 : 0;
  }

  // Otherwise remove newline and give string back to caller.
  buff[strlen(buff) - 1] = '\0';
  return 0;
}

/* Returns 0 if time1 is after time2 and 1 if time2 is after time1 */
int timeCompare(int y1, int y2, int m1, int m2) {
  if (y1 > y2) {
    return 0;
  } else if (y1 < y2) {
    return 1;
  } else {
    if (m1 > m2) {
      return 0;
    } else {
      return 1;
    }
  }
}

/* Returns 0 if time1 is after time2 and 1 if time2 is after time1 */
int timeCompareDay(int y1, int y2, int m1, int m2, int d1, int d2) {
  if (y1 > y2) {
    return 0;
  } else if (y1 < y2) {
    return 1;
  } else {
    if (m1 > m2) {
      return 0;
    } else if (m1 < m2) {
      return 1;
    } else {
      if (d1 > d2) {
        return 0;
      } else {
        return 1;
      }
    }
  }
}

int monthDiff(int y1, int y2, int m1, int m2) {
  return ((y1 - y2) * 12) + m1 - m2;
}