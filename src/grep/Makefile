all: s21_grep

s21_grep: 
	gcc -Wall -Werror -Wextra -o s21_grep s21_grep.c

clean:
	rm s21_grep

rebuild: clean all

# docker

docker: build run

build:
	docker build . -t test
	
run:
	docker run -it test
	
dockerClean:
	docker system prune
