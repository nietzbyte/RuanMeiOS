#include <kernel.h>
#include <uart.h>

void panic(const char *msg)
{
	uart_puts("\n[panic] ");
	uart_puts(msg);
	uart_puts("\n");

	for (;;)
		__asm__ volatile("wfe");
}
