ENTRY(start)

SECTIONS
{
    . = 0x7C00;

    .sector.text :
    {
        *(.sector)
    }

    .sector.data :
    {
        *(.sector.data)
    }

    .sector.rodata :
    {
        *(.sector.rodata)
    }

    .sector.footer 0x7DFE :
    {
        SHORT(0xAA55)
    }

    . = 0x7E00;

    .text :
    {
        *(.text)
    }

    .data :
    {
        *(.data)
    }

    .rodata :
    {
        *(.rodata)
    }

    .bss :
    {
        *(.bss)
    }
}
