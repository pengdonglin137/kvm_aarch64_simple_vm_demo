CC=aarch64-elf-gcc
OBJCOPY=aarch64-elf-objcopy
OBJDUMP=aarch64-elf-objdump

CFLAGS=-Wall

all: simple_virt guest
	cp ./guest.bin ./simple_virt ../../share/

simple_virt:simple_virt.c
	aarch64-linux-gnu-gcc $< -I./kernel_header/include -o $@

guest: start.o main.o misc.o gcc.ld
	$(CC) -march=armv8-a -Tgcc.ld -Wl,--gc-sections,-Map=guest.map -nostdlib -o $@ misc.o start.o main.o
	$(OBJDUMP) -D $@ > $@.dump
	$(OBJCOPY) -O binary $@ $@.bin

start.o:start.S
	$(CC) -c -march=armv8-a -nostdinc -MD -MF $@.d -ffunction-sections -fdata-sections -o $@ $<

main.o:main.c
	$(CC) -c -march=armv8-a -nostdinc -MD -MF $@.d -ffunction-sections -fdata-sections -o $@ $<

misc.o:misc.c
	$(CC) -c -march=armv8-a -nostdinc -MD -MF $@.d -ffunction-sections -fdata-sections -o $@ $<

clean:
	$(RM) *.o guest simple_virt *.map *.dump *.bin *.d

.PHONY: all clean

-include start.o.d main.o.d misc.o.d
