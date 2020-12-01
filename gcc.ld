OUTPUT_FORMAT("elf64-littleaarch64", "elf64-littleaarch64", "elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
ENTRY(start)

SECTIONS
{
	. = 0x100000;

	.text :
	{
		*(.text*)
	}

	.rodata :
	{
		. = ALIGN(8);
		*(.rodata*)
	}

	.data :
	{
		. = ALIGN(8);
		*(.data*)
	}

	.bss :
	{
		. = ALIGN(8);
		*(.bss*)
		*(COMMON)
	}
}
