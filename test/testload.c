#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

typedef struct {
	char from[4];
	char to[4];
	int day;
	int price;
} Flight;

char start[4] = {};
Flight *flights = NULL;
int nflights = 0;
int aflights = 0;

Flight *
next_flight() {
	if (nflights == aflights) {
		if (!aflights) {
			aflights = 10;
		}

		aflights *= 2;
		flights = realloc(flights, aflights * sizeof(Flight));
	}

	Flight *p = flights + nflights;
	nflights++;

	*p = (Flight) {
		from: {0, 0, 0, 0},
		to: {0, 0, 0, 0},
		day: 0,
		price: 0,
	};

	return p;
}

int
main(int argc, char **argv)
{
	int c;
	int q = 0;
	char *p = start;
	Flight *f = NULL;

	while ((c = getchar()) != EOF) {
		switch (q) {
			case 0:	// loading start
				if (isspace(c)) {
					*p = 0;
					q = 1;
					continue;
				}

				*p = c;
				p++;

				continue;

			case 1:	// loading from
				if (!f) {
					f = next_flight();
					p = f->from;
				}

				if (isspace(c)) {
					*p = 0;
					q = 2;
					p = f->to;
					continue;
				}

				*p = c;
				p++;

				continue;

			case 2:	// loading to
				if (isspace(c)) {
					*p = 0;
					q = 3;
					continue;
				}

				*p = c;
				p++;

				continue;

			case 3:	// loading day
				if (isspace(c)) {
					q = 4;
					continue;
				}

				f->day *= 10;
				f->day += c - '0';

				continue;

			case 4:	// loading price
				if (isspace(c)) {
					q = 1;
					f = NULL;
					continue;
				}

				f->price *= 10;
				f->price += c - '0';

				continue;
		}
	}

	printf("%s\n%d\n", start, nflights);
	return 0;
}
