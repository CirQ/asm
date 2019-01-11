global printHelloWorld

section .text

printHelloWorld:
	mov	r10, rdi    ;; 1 arg
	mov	r11, rsi    ;; 2 arg
	mov	rax, 1      ;; call write syscall
	mov	rdi, 1
	mov	rsi, r10
	mov	rdx, r11
	syscall
	ret
