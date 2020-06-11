CC=gcc
CFLAGS=-I.
DEPS = input.c print.c file.c data.c utils.c shared.h

make: $(OBJ)
	$(CC) -o main main.c $(DEPS) $(CFLAGS)

clean:
	rm -rf *.o main