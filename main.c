#include <ctype.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
	bool exists;
	char from[4];
	int f;
	char to[4];
	int t;
	int day;
	int price;
} Flight;

static int ncities = 0;
static char cities[300][4];
static Flight days[300][300][300];

int
find(char *city) {
	for (int i = 0; i < ncities; i++) {
		if (strcmp(cities[i], city) == 0)
			return i;
	}

	strcpy(cities[ncities], city);
	return ncities++;	// not ++ncities
}

void
add_flight(Flight f) {
	f.exists = true;

	int from = find(f.from);
	int to = find(f.to);

	f.f = from;
	f.t = to;

	days[f.day][from][to] = f;
}

void
parse() {
	int c;
	int q = 0;
	char start[4] = {0, 0, 0, 0};
	char *p = start;
	Flight f;

	while ((c = getchar()) != EOF) {
		switch (q) {
			case 0:	// loading start
				if (isspace(c)) {
					*p = 0;
					q = 5;
					find(start);
					continue;
				}

				*p = c;
				p++;

				continue;

			case 5:
				f = (Flight) {
					.exists = false,
					.from = {0, 0, 0, 0},
					.to = {0, 0, 0, 0},
					.f = 0,
					.t = 0,
					.day = 0,
					.price = 0,
				};

				p = f.from;
				q = 1;
				// pass

			case 1:	// loading from
				if (isspace(c)) {
					*p = 0;
					q = 2;
					p = f.to;
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

				f.day *= 10;
				f.day += c - '0';

				continue;

			case 4:	// loading price
				if (isspace(c)) {
					q = 5;
					add_flight(f);
					continue;
				}

				f.price *= 10;
				f.price += c - '0';

				continue;
		}

		if (q == 4)
			add_flight(f);
	}
}


int
main(int argc, char **argv)
{
	parse();

	printf("%s\n%d\n", cities[0], ncities);
	return 0;
}
