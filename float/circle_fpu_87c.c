#include <stdio.h>

extern int printResult(double result);

int printResult(double result) {
	printf("Circle area is - %f\n", result);
	return 0;
}
