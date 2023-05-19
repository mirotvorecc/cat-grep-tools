#include <getopt.h>
#include <stdio.h>

struct opt {
  int N_all;
  int N_nblank;
  int Nonprint;
  int Dollar;
  int Squeeze;
  int Tabs;
};

void parse_opt(int argc, char **argv, struct opt *cat_opt, int *c);
void file_work(FILE *file, struct opt cat_opt, int *str_count, int *f_squeeze);
int toascii(int c);

int main(int argc, char **argv) {
  struct opt cat_opt = {0, 0, 0, 0, 0, 0};
  int c = 0;
  parse_opt(argc, argv, &cat_opt, &c);
  if (c < argc) {
    int str_count = 0;
    int f_squeeze = 0;
    while (c < argc) {
      FILE *file;
      if ((file = fopen(argv[c], "r")) != NULL) {
        file_work(file, cat_opt, &str_count, &f_squeeze);
        fclose(file);
      } else {
        fprintf(stderr, "cat: %s: No such file or directory\n", argv[c]);
      }
      c++;
    }
  }
  return 0;
}

void file_work(FILE *file, struct opt cat_opt, int *str_count, int *f_squeeze) {
  int act_ch = 0;
  int prev_ch = '\n';
  while ((act_ch = fgetc(file)) != EOF) {
    if (prev_ch == '\n') {
      if (cat_opt.Squeeze) {
        if (act_ch == '\n') {
          *f_squeeze = (*f_squeeze == 0) ? 1 : 2;
        } else {
          *f_squeeze = 0;
        }
      }
      if (cat_opt.N_all && !cat_opt.N_nblank && *f_squeeze != 2) {
        printf("%6d\t", ++(*str_count));
      }
      if (cat_opt.N_nblank && *f_squeeze != 2) {
        if (act_ch != '\n') printf("%6d\t", ++(*str_count));
      }
    }
    if (cat_opt.Dollar && (act_ch == '\n' && *f_squeeze != 2)) printf("$");
    if (cat_opt.Nonprint && (act_ch != '\n' && act_ch != '\t')) {
      if (!(act_ch >= 0 && act_ch <= 127) && !(act_ch > 31 && act_ch < 127)) {
        printf("M-");
        act_ch = 127 & act_ch;
      }
      if (!(act_ch > 31 && act_ch < 127)) {
        printf("^");
        act_ch = (act_ch == 127 ? '?' : act_ch + 64);
      }
    }
    if (cat_opt.Tabs && act_ch == '\t') {
      printf("^");
      act_ch = 'I';
    }
    if (*f_squeeze != 2) printf("%c", act_ch);
    prev_ch = act_ch;
  }
}

void parse_opt(int argc, char **argv, struct opt *cat_opt, int *c) {
  struct option long_options[] = {
      {"number", 0, NULL, 'n'},
      {"number-nonblank", 0, NULL, 'b'},
      {"squeeze-blank", 0, NULL, 's'},
      {0, 0, 0, 0},
  };
  opterr = 0;
  int res = 0;
  while ((res = getopt_long(argc, argv, "+nbsevEtT", long_options, 0)) != -1) {
    if (res == 'n')
      cat_opt->N_all = 1;
    else if (res == 'b')
      cat_opt->N_nblank = 1;
    else if (res == 's')
      cat_opt->Squeeze = 1;
    else if (res == 'e') {
      cat_opt->Nonprint = 1;
      cat_opt->Dollar = 1;
    } else if (res == 'v')
      cat_opt->Nonprint = 1;
    else if (res == 'E')
      cat_opt->Dollar = 1;
    else if (res == 't') {
      cat_opt->Nonprint = 1;
      cat_opt->Tabs = 1;
    } else if (res == 'T')
      cat_opt->Tabs = 1;
  }
  *c = *c + optind;
}
