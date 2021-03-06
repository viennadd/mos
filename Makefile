
# CC = gcc
# CCFLAGS := -ffreestanding -fno-builtin -nostdinc -std=c99 \
# 	-I./kernel/include -I./kernel/drivers/include -I./loader -I.
# 	


CC = gcc
CCFLAGS := -ggdb -fno-builtin -nostdinc -std=c99 -fno-stack-protector \
	-I./kernel/include -I./kernel/drivers/include -I./loader -I.

AS = nasm
ASFLAGS = 

# ISR_WRAPPER_ASM = ./kernel/isr_wrapper.asm
ISR_WRAPPER_O = ./kernel/isr_wrapper.o

C_OBJS	= 	$(patsubst %.c, %.o, $(wildcard ./kernel/drivers/*.c) $(wildcard ./kernel/*.c))
		

kernel.bin : header/header.o kernel/gdt_flush.o $(ISR_WRAPPER_O) $(C_OBJS)
	ld -T kernel.ld -o $@ $^

%.o : %.asm
	$(AS) $< -f elf -o $@

%.o : %.c
	$(CC) $(CCFLAGS) -o $@ -c $<


.PHONY: clean
clean:
	find . -name "*.o" -type f -delete
	find . -name "*.bin" -type f -delete
