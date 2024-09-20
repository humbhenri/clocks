SRC=main.c
CC=x86_64-w64-mingw32-gcc
TARGET=clock.exe
FLAGS=-municode -mwindows -lm

$(TARGET): $(SRC)
	$(CC) $(SRC) -o $(TARGET) $(FLAGS)

.PHONY: clean
clean:
	rm -f $(TARGET)
