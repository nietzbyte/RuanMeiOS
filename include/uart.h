#ifndef _RUANMEI_UART_H
#define _RUANMEI_UART_H

#include <types.h>

void	uart_init(void);
void	uart_putc(char c);
void	uart_puts(const char *s);
void	uart_puthex(u64 value);

#endif
