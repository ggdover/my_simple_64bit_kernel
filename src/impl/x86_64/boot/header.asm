section .multiboot_header
header_start:
    ; magic number
    dd 0xe85250d6 ; multiboot2 (Info on Multiboot2: https://www.gnu.org/software/grub/manual/multiboot2/multiboot.html)
    ; architecture
    dd 0 ; protected mode 1386
    ; header length
    dd header_end - header_start
    ; checksum
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))

    ; end tag
    dw 0
    dw 0
    dd 8
header_end:
