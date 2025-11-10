flags :=
FASMENV=

.PHONY: clean run

all: bin/snake.bin

bin:
	mkdir -p bin

bin/snake.bin: snake.asm | bin
	fasm $^ $@

run:
	qemu-system-i386 -hda ./bin/snake.bin -m 512

dump:
	objdump -M intel -D -M i8086 -b binary -m i8086 ./bin/snake.bin

clean:
	rm -rf bin/*.o bin/*.bin