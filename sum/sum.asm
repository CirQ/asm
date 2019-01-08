section .data
	num1:	equ 100 ;; Define constants
	num2:	equ 50
    ans:    equ 150
	msg:	db `Sum is correct\n`
section .text
	global	_start

_start:
	mov	rax, num1
	mov	rbx, num2
	add	rax, rbx    ; get sum of num1 and num2
	cmp	rax, ans
	je	.rightSum   ; if rax is ans, print msg
	jmp	.exit       ; if rax is not ans, go to exit

.rightSum:
	mov	rax, 1      ;; write syscall
	mov	rdi, 1      ;; file descritor, standard output
	mov	rsi, msg    ;; message address
	mov	rdx, 15     ;; length of message
	syscall         ;; call write syscall

.exit:
	mov	rax, 60
	mov	rdi, 0
	syscall
