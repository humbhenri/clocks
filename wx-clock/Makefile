CC=g++
LIBS=`wx-config --libs --cxxflags`
FLAGS=-finput-charset=UTF-8
BIN=wx-clock

all: wx-clock.cpp window.o clock.o
	$(CC) -o $(BIN) wx-clock.cpp window.o clock.o $(LIBS) $(FLAGS)

window.o: window.cpp window.h
	$(CC) -c -o window.o window.cpp $(LIBS) $(FLAGS)

clock.o: clock.cpp clock.h
	$(CC) -c -o clock.o clock.cpp $(LIBS) $(FLAGS)

clean:
	rm -f $(BIN) *.o
