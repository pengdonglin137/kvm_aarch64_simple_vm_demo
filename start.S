	.global main
	.global start
	.text
start:
	mov x0, #0x101000
	mov sp, x0
	bl  main
	b .
