CC=gcc
CFLAGS=-O3 -Wall -pedantic
LDFLAGS=

a.out: main.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

clean:
	rm a.out
