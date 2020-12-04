#include "register.h"

	.global main
	.global start
	.text
start:
	ldr x0, =SP_ADDR
	mov sp, x0

	/* Clear BSS */
	ldr x0, =__BSS_START__
	ldr x1, =__BSS_END__
clear_loop:
	str	xzr, [x0], #8
	cmp	x0, x1
	b.lo	clear_loop

	bl  main

	ldr x1, =EXIT_REG
	mov x0, #1
	strb w0, [x1]
	b .
