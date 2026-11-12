#ifndef _RUANMEI_TYPES_H
#define _RUANMEI_TYPES_H

typedef signed char		s8;
typedef unsigned char		u8;
typedef signed short		s16;
typedef unsigned short		u16;
typedef signed int		s32;
typedef unsigned int		u32;
typedef signed long long	s64;
typedef unsigned long long	u64;

typedef u64	size_t;
typedef u64	uintptr_t;
typedef s64	intptr_t;

typedef _Bool	bool;

#define true	1
#define false	0

#ifndef NULL
#define NULL	((void *)0)
#endif

#define ARRAY_SIZE(x)	(sizeof(x) / sizeof((x)[0]))

#endif
