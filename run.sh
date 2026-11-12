#!/bin/sh
# Boot the kernel on QEMU's ARM64 "virt" machine.
# Exit QEMU with Ctrl-A then X.

set -eu

QEMU="${QEMU:-qemu-system-aarch64}"
KERNEL="${KERNEL:-build/kernel.elf}"

if [ ! -f "$KERNEL" ]; then
	echo "kernel not found: $KERNEL (run 'make' first)" >&2
	exit 1
fi

exec "$QEMU" \
	-M virt \
	-cpu cortex-a57 \
	-m 256M \
	-nographic \
	-kernel "$KERNEL" \
	"$@"
