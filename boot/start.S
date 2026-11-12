/*
 * RuanMeiOS - ARM64 boot entry
 *
 * The first 64 bytes mirror the Linux arm64 Image header:
 *   code0/code1 are executable (nop + branch), followed by the
 *   text_offset/image_size/flags/reserved fields and the "ARM\x64"
 *   magic. This keeps the flat Image compatible with Linux-style
 *   boot loaders while the ELF entry stays at _start.
 */

	.section .text.boot, "ax"
	.global _start
_start:
	nop				/* code0 */
	b	_entry			/* code1 */
	.quad	0x200000		/* text_offset: 2 MiB above RAM base */
	.quad	__image_end - _start	/* image_size */
	.quad	0			/* flags */
	.quad	0			/* res2 */
	.quad	0			/* res3 */
	.quad	0			/* res4 */
	.word	0x644d5241		/* magic: "ARM\x64" */
	.word	0			/* res5 */

_entry:
	/* Mask all interrupts (Debug, SError, IRQ, FIQ). */
	msr	daifset, #0xf

	/* Preserve the FDT pointer supplied by the boot loader in x0. */
	mov	x19, x0

	/* Clear BSS. The boot stack lives inside BSS and is cleared too. */
	ldr	x0, =__bss_start
	ldr	x1, =__bss_end
	mov	x2, #0
1:
	cmp	x0, x1
	b.hs	2f
	str	x2, [x0], #8
	b	1b
2:
	/* Set up the stack. */
	ldr	x0, =__stack_top
	mov	sp, x0

	/* Clean frame pointer and link register. */
	mov	x29, #0
	mov	x30, #0

	/* Jump into C: kmain(fdt). */
	mov	x0, x19
	bl	kmain

3:
	wfe
	b	3b
