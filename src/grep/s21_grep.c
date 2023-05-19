//  Copyright 2022 <Copyright Aimeebro>

#include <getopt.h>
#include <regex.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct opt {
  int c, e, f, h, i, l, n, o, s, v;
};

char *parse_opt_get_pattern(int argc, char **argv, struct opt *cat_opt);
void file_work(FILE *file, struct opt flag, char *pattern, char Multi_Files,
               char *filename);
char *add_pattern(char *pattern, const char *str, int *i, int *M);
void output(struct opt flag, char *filename, char *f_line, FILE *file,
            int Multi_Files, int num_of_line);

int main(int argc, char **argv) {
  if (argc > 1) {
    struct opt flag = {0};
    char *pattern;
    if (NULL != (pattern = parse_opt_get_pattern(argc, argv, &flag))) {
      char Multi_Files =
          ((argv[optind + 1 + !(flag.e || flag.f)] != NULL && !(flag.h)) ? 1
                                                                         : 0);
      for (; argv[optind + !(flag.e || flag.f)] != NULL; optind++) {
        FILE *file;
        if ((file = fopen(argv[optind + !(flag.e || flag.f)], "r")) != NULL) {
          file_work(file, flag, pattern, Multi_Files,
                    argv[optind + !(flag.e || flag.f)]);
          fclose(file);
        } else if (!flag.s) {
          fprintf(stderr, "grep: %s: No such file or directory\n",
                  argv[optind + !(flag.e || flag.f)]);
        }
      }
      if (flag.e || flag.f) free(pattern);
    }
  }
  return 0;
}

void file_work(FILE *file, struct opt flag, char *pattern, char Multi_Files,
               char *filename) {
  char f_line[1000] = {0};
  int reg_flag = REG_NEWLINE;
  regex_t reg;
  if (flag.e || flag.f) reg_flag = REG_EXTENDED;
  if (flag.i)
    reg_flag = ((flag.e || flag.f) ? REG_ICASE | REG_EXTENDED : REG_ICASE);
  regcomp(&reg, pattern, reg_flag);
  // size_t nmatch = 0;
  // regmatch_t pmatch[];
  if (flag.f != -1) {
    char last_char = 10;
    int num_of_line = 0;
    int count_compare = 0;
    while (fgets(f_line, 1000, file) != NULL) {
      num_of_line++;
      if (flag.v && regexec(&reg, f_line, 0, NULL, 0) != 0) {
        last_char = f_line[strlen(f_line) - 1];
        count_compare++;
        output(flag, filename, f_line, file, Multi_Files, num_of_line);
      } else if (!(flag.v) && !regexec(&reg, f_line, 0, NULL, 0)) {
        last_char = f_line[strlen(f_line) - 1];
        count_compare++;
        output(flag, filename, f_line, file, Multi_Files, num_of_line);
      }
    }
    if (flag.c && !(flag.l)) {
      if (Multi_Files) printf("%s:%d\n", filename, count_compare);
      if (!Multi_Files) printf("%d\n", count_compare);
    }
    if (!(flag.l || flag.c) && last_char != '\n') {
      printf("\n");
    }
  }
  regfree(&reg);
}

void output(struct opt flag, char *filename, char *f_line, FILE *file,
            int Multi_Files, int num_of_line) {
  if (flag.l) {
    printf("%s\n", filename);
    fseek(file, 0, SEEK_END);
  } else if (!(flag.c)) {
    if (Multi_Files) printf("%s:", filename);
    if (flag.n) printf("%d:", num_of_line);
    printf("%s", f_line);
  }
}

char *parse_opt_get_pattern(int argc, char **argv, struct opt *flag) {
  struct option long_options[] = {
      {"count", no_argument, NULL, 'c'},
      {"regexp=", required_argument, NULL, 'e'},
      {"file=", required_argument, NULL, 'f'},
      {"no-filename", no_argument, NULL, 'h'},
      {"ignore-case", no_argument, NULL, 'i'},
      {"files-with-matches", no_argument, NULL, 'l'},
      {"line-number", no_argument, NULL, 'n'},
      {"only-matching", no_argument, NULL, 'o'},
      {"no-messages", no_argument, NULL, 's'},
      {"invert-match", no_argument, NULL, 'v'},
      {0, 0, 0, 0}};
  opterr = 0;
  int i = 0, M = 1000;
  char *reg_phrase = (char *)calloc(M, sizeof(char));
  if (NULL != reg_phrase) {
    int res = 0, need_pattern = 1;
    while ((res = getopt_long(argc, argv, "ce:f:hilnosv", long_options,
                              NULL)) != -1) {
      if (res == 'c') {
        flag->c = 1;
      } else if (res == 'e') {
        flag->e = 1;
        need_pattern = 0;
        reg_phrase = add_pattern(reg_phrase, optarg, &i, &M);
      } else if (res == 'f') {
        flag->f = 1;
        need_pattern = 0;
        FILE *reg_file;
        if ((reg_file = fopen(optarg, "r")) != NULL) {
          char buff[1000];
          while (fgets(buff, 1000, reg_file) != NULL) {
            reg_phrase = add_pattern(reg_phrase, buff, &i, &M);
          }
        } else {
          fprintf(stderr, "grep: %s: No such file or directory\n", optarg);
          flag->f = -1;
        }
      } else if (res == 'h')
        flag->h = 1;
      else if (res == 'i')
        flag->i = 1;
      else if (res == 'l')
        flag->l = 1;
      else if (res == 'n')
        flag->n = 1;
      else if (res == 'o')
        flag->o = 1;
      else if (res == 's')
        flag->s = 1;
      else if (res == 'v')
        flag->v = 1;
    }
    if (i != 0) reg_phrase[i - 1] = 0;
    if (need_pattern) {
      free(reg_phrase);
      reg_phrase = argv[optind];
    }
  }
  return reg_phrase;
}

char *add_pattern(char *pattern, const char *str, int *i, int *M) {
  for (int j = 0; str[j] != 0; j++, *i = *i + 1) {
    if (*i == *M - 2) {
      *M += *M;
      void *tmp = (char *)realloc(pattern, *M * sizeof(char));
      if (tmp == NULL) {
        free(tmp);
      } else {
        pattern = tmp;
      }
    }
    pattern[*i] = str[j];
    if (str[j] == '\n') *i = *i - 1;
  }
  if (pattern[*i - 1] != '|') {
    pattern[*i] = '|';
    *i = *i + 1;
  }
  return pattern;
}
