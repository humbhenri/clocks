CC=gcc
BIN=gtk-clock
LIBS=`pkg-config --libs --cflags gtk+-2.0` -lm

$(BIN): gtk-clock.c clockwidget.o
	$(CC) -o $@ $^ $(LIBS)


clockwidget.o: clockwidget.c 
	$(CC) -c -o $@ $^ $(LIBS)

.PHONY: clean
clean:
	rm -f $(BIN) *.o
