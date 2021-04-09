// utils
// C common utilities
//
// Author: Álvaro Galisteo (https://alvaro.galisteo.me)
// Copyright 2020 - GPLv3

void trim(char *str);
char *gen_string(char *string);
int get_color(char *string);
int getLine(char *prmpt, char *buff, int sz);
int timeCompare(int y1, int y2, int m1, int m2);
int timeCompareDay(int y1, int y2, int m1, int m2, int d1, int d2);
int monthDiff(int y1, int y2, int m1, int m2);