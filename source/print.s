BITS	16

SECTION	.sector.text

; Prints a null-terminated string.
;       si: string to print
print:
        push    ax
        mov     ah, 0x0E
.loop:
        lodsb
        test    al, al
        jz      .done
        int     0x10
        jmp     .loop
.done:
        pop     ax
        ret

; Prints a hexadecimal.
;	ax: number to print
print_hexadecimal:
        pusha

        ; Since we are using the stack to allocate a string of bytes
        ; representing digits, we first have to push the null terminator.
        push    0x00

        ; This counter is used for counting the number of words pushed on the
        ; Stack, not the number of bytes.
        ; Its primary use is to later pop the string of bytes.
        mov     cx, 0x01
.loop: 

        ; We first get hexadecimal digit as an ASCII character by using an
        ; array of ASCII hexadecimal digits as a map.
        mov     bx, ax          ; Save the state of ax.
        and     bx, 0x0F        ; Get the lower 4 bits as the offset to the
                                ; corresponding ascii character.
        lea     si, [digit_map] ; Load the ascii digits.
        add     si, bx          ; Get the address of the ascii digit using the
                                ; offset.
        mov     bl, [si]        ; Get the ascii digit.
        pop     dx              ; Load the previously pushed word.
        test    dl, dl          ; Check if the previous digit is null.
        jz      .push_low

        ; There existed a previous digit which means the word in which the
        ; previous digit occupies is full.
        ; Therefore, we push back the word and create a new word with the
        ; current digit occupying the high byte.
        push    dx              ; Push back the full word.
        shl     bx, 0x08        ; Move the digit to the high byte.
        inc     cx              ; Increment the counter because a new word is
                                ; being created.
        jmp     .push
.push_low: 

        ; The previous word had null occupying the low byte.
        ; Therefore, we put the current digit in place of the low byte to fill
        ; the word.
        mov     bh, dh
.push: 
        push    bx       ; Concatenate the string of digits using the word.
        shr     ax, 0x04 ; Pop the bits that have been read.
        test    ax, ax   ; Check if there are no more bits to read.
        jnz     .loop

        ; Since the last word can have null occupying the low byte, we have to
        ; deduct the last byte.
        ; Otherwise, the string won't print because a null terminator occupies
        ; the first read byte.
        mov     si, sp ; Save the state of the stack ptr.
        pop     ax     ; Load the last word.
        test    al, al ; Check if the low byte is null.
        push    ax     ; Push back the word.
        jnz     .print

        ; The word had null in the low byte, so we increment the string pionter
        ; So that the null byte won't be read.
        inc     si
.print: 
        call    print ; Print the string.

        ; We now have a useless string pushed onto the stack.
        ; Since we counted the amount of words pushed onto the stack, we first
        ; multiply the counter by 2 to remove a each byte because a word is 2
        ; bytes.
        shl     cx, 0x01 ; Multiply the string by 2.
        add     sp, cx   ; Pop the string. popa
        ret

SECTION .sector.rodata

digit_map:      db '0123456789ABCDEF'
