section .data       ;; initialized data
	SYS_WRITE	equ 1
	SYS_EXIT	equ 60
	STD_OUT		equ 1
	EXIT_CODE	equ 0
	NEW_LINE	db 0xa
	INPUT		db "Hello world!"
section .bss        ;; non initialized data
	OUTPUT	resb 1
section .text       ;; code
	global	_start

_start:
	mov	rsi, INPUT          ;; get addres of INPUT
	xor	rcx, rcx            ;; zeroize rcx for counter
	cld                     ;; df = 0 si++
	mov	rdi, $ + 15         ;; remember place after function call
	call calculateStrLength ;; get string length
	xor	rax, rax            ;; write zeros to rax
	xor	rdi, rdi            ;; additional counter for reverseStr
	jmp	reverseStr          ;; reverse string

calculateStrLength:
	cmp	byte [rsi], 0       ;; check is it end of string
	je	exitFromRoutine     ;; if yes exit from function
	lodsb                   ;; load byte from rsi to al and inc rsi
	push	rax             ;; push symbol to stack
	inc	rcx                 ;; increase counter
	jmp	calculateStrLength  ;; loop again
exitFromRoutine:
	push	rdi             ;; push return addres to stack again
	ret                     ;; return to _start

;; 31 in stack
reverseStr:
	cmp	rcx, 0              ;; check is it end of string
	je	printResult         ;; if yes print result string
	pop	rax                 ;; get symbol from stack
	mov	[OUTPUT + rdi], rax ;; write it to output buffer
	dec	rcx                 ;; decrease length counter
	inc	rdi                 ;; increase additional length counter (for write syscall)
	jmp	reverseStr          ;; loop again

printResult:
	mov	rdx, rdi
	mov	rax, 1
	mov	rdi, 1
	mov	rsi, OUTPUT
	syscall
	jmp	printNewLine

printNewLine:
	mov	rax, SYS_WRITE
	mov	rdi, STD_OUT
	mov	rsi, NEW_LINE
	mov	rdx, 1
	syscall
	jmp	exit

exit:
	mov	rax, SYS_EXIT
	mov	rdi, EXIT_CODE
	syscall
