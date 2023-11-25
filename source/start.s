BITS    16

SECTION .sector.text

GLOBAL  start
start:
        ; setup the Stack
        mov     bp, $$
        mov     sp, $$

        ; save any variables the BIOS gave
        mov     [boot_drive], dl

        ;
        ; initialize the screen
        ;

        ; clear the screen
        mov     ah, 0x06
        mov     al, 0x00
        mov     ch, 0x00
        mov     cl, 0x00
        mov     dh, 0x19
        mov     dl, 0x50
        mov     bh, 0x07
        int     0x10

        ; set the cursor position
        mov     ah, 0x02
        mov     bh, 0x00
        mov     dh, 0x00
        mov     dl, 0x00
        int     0x10

        ;
        ; load the rest of the bootloader
        ;

        ;; read the disk
        ;mov     al, 0x01
        ;mov     bx, 0x7E00
        ;mov     ch, 0x00
        ;mov     cl, 0x02
        ;mov     dh, 0x00
        ;mov     dl, [boot_drive]
        ;; omitting es (it's already set to 0x00)
        ;call    read_disk

        ;
        ; switch control stage 2
        ;
        mov     si, hello_msg
        call    print
        jmp     $


; print to the screen a failure message and halt.
; this function should be jumped to, not called.
;       si: failure message
failure:
        call    print
        cli
        jmp     $

%include 'print.s'
%include 'disk.s'

SECTION .sector.data

boot_drive:     db 0

SECTION .sector.rodata

hello_msg:      db 'Hello, World!', 0
