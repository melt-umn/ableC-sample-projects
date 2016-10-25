
accounting.c:	accounting.xc compiler/ableC.jar
	java -jar compiler/ableC.jar accounting.xc

accounting.o:	accounting.c
	gcc -c accounting.c

livestock.c:	livestock.xc livestock.h compiler/ableC.jar
	java -jar compiler/ableC.jar livestock.xc

livestock.o:	livestock.c
	gcc -c livestock.c

a.out:	accounting.o livestock.o
	gcc accounting.o livestock.o

clean:
	rm -f *.c *.i *.o a.out *~


# Build the ableC compiler
compiler/ableC.jar:
	cd compiler; ./build.sh

# Remove the generated compile so that it will be re-built.
cleanjar:
	rm -f compiler/ableC.jar
