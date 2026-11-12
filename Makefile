# RuanMeiOS - ARM64 kernel
# Toolchain: Homebrew LLVM (clang + lld + llvm-objcopy) on macOS.

TARGET      := aarch64-none-elf
LLVM_PREFIX ?= /opt/homebrew/opt/llvm/bin
CC          := $(LLVM_PREFIX)/clang
OBJCOPY     := $(LLVM_PREFIX)/llvm-objcopy

BUILD       := build
KERNEL_ELF  := $(BUILD)/kernel.elf
KERNEL_IMG  := $(BUILD)/Image

ARCHFLAGS   := --target=$(TARGET) -ffreestanding -fno-pic -fno-pie \
               -fno-stack-protector -mno-outline-atomics -mgeneral-regs-only
CFLAGS      := $(ARCHFLAGS) -std=gnu11 -O2 -g -Wall -Wextra -Iinclude
ASFLAGS     := $(ARCHFLAGS) -Iinclude
LDFLAGS     := $(ARCHFLAGS) -fuse-ld=lld -nostdlib -static \
               -Wl,-T,boot/linker.ld -Wl,--build-id=none

OBJS        := $(BUILD)/boot/start.o \
               $(BUILD)/kernel/main.o \
               $(BUILD)/kernel/panic.o \
               $(BUILD)/drivers/uart/pl011.o \
               $(BUILD)/lib/string.o

.PHONY: all clean run

all: $(KERNEL_ELF) $(KERNEL_IMG)

$(KERNEL_ELF): $(OBJS) boot/linker.ld
	$(CC) $(LDFLAGS) -o $@ $(OBJS)

$(KERNEL_IMG): $(KERNEL_ELF)
	$(OBJCOPY) -O binary $< $@

$(BUILD)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD)/%.o: %.S
	@mkdir -p $(dir $@)
	$(CC) $(ASFLAGS) -c $< -o $@

run: all
	sh ./run.sh

clean:
	rm -rf $(BUILD)
