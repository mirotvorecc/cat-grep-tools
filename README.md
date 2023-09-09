# cat-grep-tools — Minimal Unix `cat` & `grep` Reimplementation in C

This project provides a simplified reimplementation of the classic Unix command-line tools `cat` and `grep` written in C. It was developed as part of a systems programming curriculum to gain practical experience with file I/O, command-line argument parsing, and POSIX regular expressions.

## Features

### `cat`
- Supports flags: `-b`, `-e`, `-n`, `-s`, `-t`, `-v`
- Handles multiple file inputs
- Behavior closely matches GNU `cat`

### `grep`
- Supports flags: `-e`, `-i`, `-v`, `-c`, `-l`, `-n`, `-h`, `-s`, `-f`, `-o`
- Reads patterns from both command-line and file
- Implements pattern matching via `regex.h` (POSIX)

## Project Structure

- [`src/`](src/): C source files for `s21_cat` and `s21_grep`
- [`README.md`](README.md): Project documentation

## Usage

1. Run the tools:

    ```bash
    ./s21_cat [OPTIONS] [FILE...]
    ./s21_grep [OPTIONS] PATTERN [FILE...]
    ```

## Requirements

- GCC
- Unix-like environment (Linux/macOS)
- POSIX-compliant shell

## Notes

- Code is written in compliance with Google C Style.
- This project is intended for educational and demonstrative purposes.
