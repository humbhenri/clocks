TARGET = clock
ASM = fasm

$(TARGET): $(TARGET).asm
	$(ASM) $(TARGET).asm
	ld -o $(TARGET) $(TARGET).o -L/usr/lib/x86_64-linux-gnu -lSDL2 -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

clean:
	rm -rf $(TARGET) $(TARGET).o

.PHONY: clean
