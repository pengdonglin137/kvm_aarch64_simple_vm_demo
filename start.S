#include "register.h"

	.global main
	.global start
	.text
start:
	ldr x0, =SP_REG
	mov sp, x0

	bl  main

	ldr x1, =EXIT_REG
	mov x0, #1
	strb w0, [x1]
	b .
