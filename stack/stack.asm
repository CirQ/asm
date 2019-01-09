section .data
	SYS_WRITE	equ 1
	SYS_EXIT	equ 60
	STD_IN		equ 1
	EXIT_CODE	equ 0
	NEW_LINE	db 0xa
	WRONG_ARGC	db "Must be two command line argument", 0xa

section .text
	global	_start

_start:
	pop	rcx             ;; rcx - argc

	;; Check argc
	cmp	rcx, 3
	jne	argcError

	;; start to sum arguments
	add	rsp, 8          ;; skip argv[0] - program name
	pop	rsi             ;; get argv[1]
	call str_to_int     ;; convert argv[1] str to int
	mov	r10, rax        ;; put first num to r10
	pop	rsi             ;; get argv[2]
	call str_to_int     ;; convert argv[2] str to int
	mov	r11, rax        ;; put second num to r10

	;; Convert to string
	add	r10, r11        ;; sum it
	mov	rdi, r10
	call int_to_str     ;; convert to string

;;
;; Print argc error
;;
argcError:
	mov	rax, 1          ;; sys_write syscall
	mov	rdi, 1          ;; file descritor, standard output
	mov	rsi, WRONG_ARGC ;; message address
	mov	rdx, 34         ;; length of message
	syscall             ;; call write syscall
	jmp	exit            ;; exit from program

;;
;; Convert int to string
;;
int_to_str:
    mov rax, rdi
	xor	r12, r12        ;; number counter
loop:
	mov	rdx, 0          ;; reminder from division
	mov	rbx, 10         ;; base
	div	rbx             ;; rax = rax / 10
	add	rdx, 48         ;; add \0
	add	rdx, 0x0
	push rdx            ;; push reminder to stack
	inc	r12             ;; go next
	cmp	rax, 0x0        ;; check factor with 0
	jne	loop            ;; loop again
	jmp	print           ;; print result

;;
;; Convert string to int
;;
str_to_int:
	xor	rax, rax        ;; accumulator
	mov	rcx,  10        ;; base for multiplication
next:
	cmp	[rsi], byte 0   ;; check that it is end of string
	je return_str       ;; return int
	mov	bl, [rsi]       ;; mov current char to bl
	sub	bl, 48          ;; get number
	mul	rcx             ;; rax = rax * 10
	add	rax, rbx        ;; ax = ax + digit
	inc	rsi             ;; get next number
	jmp	next            ;; again
return_str:
	ret

;;
;; Print number
;;
print:
	;; calculate number length
	mov	rax, 1
	mul	r12
	mov	r12, 8
	mul	r12
	mov	rdx, rax

	;; print sum
	mov	rax, SYS_WRITE
	mov	rdi, STD_IN
	mov	rsi, rsp
	syscall
	jmp	printNewline

;;
;; Print number
;;
printNewline:
	mov	rax, SYS_WRITE
	mov	rdi, STD_IN
	mov	rsi, NEW_LINE
	mov	rdx, 1
	syscall
	jmp	exit

;;
;; Exit from program
;;
exit:
	mov	rax, SYS_EXIT
	mov	rdi, EXIT_CODE
	syscall
