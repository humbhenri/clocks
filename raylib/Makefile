TARGET=raylib
SRC=raylib.c
LD_FLAGS=-lraylib -lGL -lm -lpthread -ldl -lrt -lX11

.PHONY: clean

$(TARGET): $(SRC)
	cc $(SRC) -o $(TARGET) $(LD_FLAGS)

clean:
	rm -f $(TARGET)
