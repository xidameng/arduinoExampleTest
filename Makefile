all: compile

.PHONY: compile check

compile: test.c
	gcc test.c -o test.out
	@echo "GCC compilation finished"

check: test.out
	./test.out

