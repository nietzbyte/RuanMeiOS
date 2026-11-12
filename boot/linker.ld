/*
 * RuanMeiOS - ARM64 linker script
 *
 * The kernel is linked at 0x40200000: QEMU's arm64 Linux Image loader
 * places the kernel 2 MiB above the RAM base (0x40000000) so the image
 * is 2 MiB aligned. The ELF and flat Image therefore share one base.
 *
 * The first bytes of .text boot mirror the Linux arm64 Image header,
 * so the resulting flat image is also accepted by Linux boot loaders.
 */

ENTRY(_start)

SECTIONS
{
	. = 0x40200000;

	.text : ALIGN(4096) {
		KEEP(*(.text.boot))
		*(.text .text.*)
	}

	.rodata : ALIGN(4096) {
		*(.rodata .rodata.*)
	}

	.data : ALIGN(4096) {
		*(.data .data.*)
	}

	.bss (NOLOAD) : ALIGN(16) {
		__bss_start = .;
		*(.bss .bss.*)
		*(COMMON)
		. = ALIGN(16);
		. += 0x20000;		/* 128 KiB boot stack */
		__stack_top = .;
		. = ALIGN(16);
		__bss_end = .;
	}

	__image_end = .;

	/DISCARD/ : {
		*(.comment)
		*(.note .note.*)
		*(.eh_frame .eh_frame_hdr)
	}
}
