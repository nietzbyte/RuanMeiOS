#ifndef _RUANMEI_IO_H
#define _RUANMEI_IO_H

#include <types.h>

static inline void mmio_write32(u64 addr, u32 value)
{
	*(volatile u32 *)(uintptr_t)addr = value;
}

static inline u32 mmio_read32(u64 addr)
{
	return *(volatile u32 *)(uintptr_t)addr;
}

#endif
