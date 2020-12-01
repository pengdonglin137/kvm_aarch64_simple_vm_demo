CC=aarch64-elf-gcc
OBJCOPY=aarch64-elf-objcopy
OBJDUMP=aarch64-elf-objdump

CFLAGS=-Wall

all: simple_virt guest
	cp ./guest.bin ./simple_virt ../../share/

simple_virt:simple_virt.c
	aarch64-linux-gnu-gcc $< -I./kernel_header/include -o $@

guest: start.o main.o gcc.ld
	$(CC) -march=armv8-a -Tgcc.ld -Wl,-Map=guest.map -nostdlib -o $@ start.o main.o
	$(OBJDUMP) -D $@ > $@.dump
	$(OBJCOPY) -O binary $@ $@.bin

start.o:start.S
	$(CC) -c -march=armv8-a -nostdinc -o $@ $<

main.o:main.c
	$(CC) -c -march=armv8-a -nostdinc -o $@ $<

clean:
	$(RM) *.o guest simple_virt *.map *.dump *.bin

.PHONY: all clean

