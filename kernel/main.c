#include <kernel.h>
#include <uart.h>

extern char __bss_start[];
extern char __bss_end[];

static u64 read_current_el(void)
{
	u64 el;

	__asm__ volatile("mrs %0, CurrentEL" : "=r"(el));

	return (el >> 2) & 0x3;
}

void kmain(void *fdt)
{
	uart_init();

	uart_puts("\n");
	uart_puts("========================================\n");
	uart_puts("  RuanMeiOS - ARM64 kernel\n");
	uart_puts("========================================\n");
	uart_puts("[boot] entered kernel\n");

	uart_puts("[boot] exception level: EL");
	uart_putc((char)('0' + read_current_el()));
	uart_puts("\n");

	uart_puts("[boot] device tree: ");
	if (fdt) {
		uart_puthex((u64)fdt);
		uart_puts("\n");
	} else {
		uart_puts("none\n");
	}

	uart_puts("[boot] bss: ");
	uart_puthex((u64)__bss_start);
	uart_puts(" - ");
	uart_puthex((u64)__bss_end);
	uart_puts("\n");

	uart_puts("[boot] boot complete, halting CPU\n");

	for (;;)
		__asm__ volatile("wfe");
}
