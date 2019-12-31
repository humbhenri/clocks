CC=gcc
BIN=gtk-clock
LIBS=`pkg-config --libs --cflags gtk+-3.0` -lm

$(BIN): gtk3.o
	$(CC) -o $@ $^ $(LIBS)


gtk3.o: gtk3.c 
	$(CC) -c -o $@ $^ $(LIBS)

.PHONY: clean
clean:
	rm -f $(BIN) *.o
