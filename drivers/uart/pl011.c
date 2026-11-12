#include <io.h>
#include <uart.h>

/*
 * QEMU "virt" exposes a PL011 UART at 0x09000000.
 */
#define PL011_BASE	0x09000000ULL

#define UART_DR		(PL011_BASE + 0x00)
#define UART_FR		(PL011_BASE + 0x18)
#define UART_IBRD	(PL011_BASE + 0x24)
#define UART_FBRD	(PL011_BASE + 0x28)
#define UART_LCRH	(PL011_BASE + 0x2c)
#define UART_CR		(PL011_BASE + 0x30)

#define UART_FR_TXFF	(1u << 5)

#define UART_CR_UARTEN	(1u << 0)
#define UART_CR_TXE	(1u << 8)
#define UART_CR_RXE	(1u << 9)

#define UART_LCRH_FEN	(1u << 4)
#define UART_LCRH_WLEN8	(3u << 5)

void uart_init(void)
{
	mmio_write32(UART_CR, 0);
	mmio_write32(UART_IBRD, 13);
	mmio_write32(UART_FBRD, 0);
	mmio_write32(UART_LCRH, UART_LCRH_WLEN8 | UART_LCRH_FEN);
	mmio_write32(UART_CR, UART_CR_UARTEN | UART_CR_TXE | UART_CR_RXE);
}

void uart_putc(char c)
{
	while (mmio_read32(UART_FR) & UART_FR_TXFF)
		;

	mmio_write32(UART_DR, (u32)(u8)c);
}

void uart_puts(const char *s)
{
	while (*s) {
		if (*s == '\n')
			uart_putc('\r');
		uart_putc(*s++);
	}
}

void uart_puthex(u64 value)
{
	static const char hex[] = "0123456789abcdef";
	int shift;

	uart_puts("0x");
	for (shift = 60; shift >= 0; shift -= 4)
		uart_putc(hex[(value >> shift) & 0xf]);
}
