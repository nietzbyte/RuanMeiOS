#include <string.h>

void *memset(void *dst, int c, size_t n)
{
	u8 *p = dst;
	u8 v = (u8)c;

	while (n--)
		*p++ = v;

	return dst;
}

void *memcpy(void *dst, const void *src, size_t n)
{
	u8 *d = dst;
	const u8 *s = src;

	while (n--)
		*d++ = *s++;

	return dst;
}

void *memmove(void *dst, const void *src, size_t n)
{
	u8 *d = dst;
	const u8 *s = src;

	if (d < s) {
		while (n--)
			*d++ = *s++;
	} else {
		d += n;
		s += n;
		while (n--)
			*--d = *--s;
	}

	return dst;
}

size_t strlen(const char *s)
{
	const char *p = s;

	while (*p)
		p++;

	return (size_t)(p - s);
}
