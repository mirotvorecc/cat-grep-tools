all: s21_cat

s21_cat: 
	gcc -Wall -Werror -Wextra s21_cat.c -o s21_cat
	
clean:
	rm s21_cat

rebuild: clean all

# docker

docker: build run

build:
	docker build . -t test
	
run:
	docker run -it test
	
dockerClean:
	docker system prune
