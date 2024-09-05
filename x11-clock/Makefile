SRC=main.c
TARGET=main
LIBS=-lX11 -lm

main: $(SRC)
	cc $(SRC) -o $(TARGET) $(LIBS)

.PHONY: clean prof
clean:
	rm -f $(TARGET) $(TARGET)_pg gmon.out analisys.txt

$(TARGET)_pg: $(SRC)
	cc $(SRC) -o $(TARGET)_pg $(LIBS) -pg

gmon.out:
	./$(TARGET)_pg

analysis.txt: $(TARGET)_pg gmon.out
	gprof $(TARGET)_pg gmon.out > analysis.txt

prof: analysis.txt
	cat analysis.txt
