#include <string.h>

int main() {
	char* str = "Hello World\n";
	long len = strlen(str);
	int ret = 0;

	__asm__(
        "movq $1, %%rax \n\t"
		"movq $1, %%rdi \n\t"
		"movq %1, %%rsi \n\t"
		"movl %2, %%edx \n\t"
		"syscall"
		: "=g"(ret)             // return value
		: "g"(str), "g"(len)    // parameters
    );

	return 0;
}
