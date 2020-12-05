#include "register.h"

#define CPACR_EL1_FPEN    (3 << 20)

	.global main
	.global start
	.global panic
	.text
start:
	ldr x0, =__stack
	mov sp, x0

	// Enable floating point
	mov x0, #CPACR_EL1_FPEN
	msr CPACR_EL1, x0

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

