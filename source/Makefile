BUILD := ../build
TARGET := $(BUILD)/../boot.bin
OBJECTS := start.o
OBJECTS := $(addprefix $(BUILD)/,$(OBJECTS))

AS := nasm
ASFLAGS := -f elf32

LD := ld
LDSCRIPT := script.ld
LDFLAGS := -T $(LDSCRIPT) -m elf_i386

.PHONY: boot
all: $(BUILD) $(TARGET)

$(TARGET): $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $^
	objcopy -O binary $@ $@
	truncate -s 1M $@

$(BUILD)/%.o: %.s
	$(AS) $(ASFLAGS) -o $@ $^

$(BUILD):
	@mkdir -p $@

clean:
	@rm -f $(BUILD)/*
