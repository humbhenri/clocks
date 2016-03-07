CC=gcc
BIN=gtk-clock
LIBS=`pkg-config --libs --cflags gtk+-2.0` -lm

all: gtk-clock.c clockwidget.o
	$(CC) -o $(BIN) gtk-clock.c clockwidget.o $(LIBS)


clockwidget.o: clockwidget.c clockwidget.h
	$(CC) -c -o clockwidget.o clockwidget.c $(LIBS)

clean:
	rm -f $(BIN) *.o
