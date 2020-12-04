OUTPUT_FORMAT("elf64-littleaarch64", "elf64-littleaarch64", "elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
ENTRY(start)

SECTIONS
{
	. = 0x100000;

	.text :
	{
		start.o (.text*)
		*(.text*)
	}

	.rodata :
	{
		. = ALIGN(16);
		*(.rodata*)
	}

	.data :
	{
		. = ALIGN(16);
		*(.data*)
	}

	.bss :
	{
		. = ALIGN(16);
		__BSS_START__ = .;
		*(.bss*)
		*(COMMON)
		. = ALIGN(16);
		__BSS_END__ = .;
	}
	__BSS_SIZE__ = SIZEOF(.bss);
}
