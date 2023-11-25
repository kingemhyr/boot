BITS    16

SECTION .sector.text

; reads sectors from a disk into a specified address.
;   al: number of sectors to read
;   bx: buffer segment offset
;   ch: track number
;   cl: sector number
;   dh: disk side number (0 or 1)
;   dl: disk drive number
;   es: buffer segment address
read_disk:
    pusha
    push    ax
    clc
    mov     ah, 0x02
    int     0x13
    jc      .failure
    pop     bx
    cmp     al, bl
    jne     .failure
    popa
    ret
.failure:
    mov     si, disk_failure_msg
    jmp     $

SECTION .sector.rodata

disk_failure_msg:   db 'Disk failure!', 0
