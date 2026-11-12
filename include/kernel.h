#ifndef _RUANMEI_KERNEL_H
#define _RUANMEI_KERNEL_H

#include <types.h>

void	kmain(void *fdt);
void	panic(const char *msg) __attribute__((noreturn));

#endif
