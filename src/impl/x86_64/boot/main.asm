global start

section .text
bits 32
start:
    ; print 'OK'
    ; Put data 0x2f4b2f4f (data that represents 'OK' print) at address 0xb8000 (address where video memory begins)
    mov dword [0xb8000], 0x2f4b2f4f
    hlt ; halt instruction. Instruct CPU to completely freeze and not execute any further instruction
