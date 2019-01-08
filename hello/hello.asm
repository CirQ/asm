section .data
	msg	db "hello, world!",`\n`
section .text
	global	_start

_start:
	mov	rax, 1      ;; write syscall
	mov	rdi, 1      ;; file descriptor, standard output
	mov	rsi, msg    ;; message address
	mov	rdx, 14     ;; length of message
	syscall         ;; call write syscall

	mov	rax, 60     ;; exit
	mov	rdi, 0
	syscall         ;; x86-64 syscall invocation
