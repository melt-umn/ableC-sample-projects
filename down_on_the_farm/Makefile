
accounting.c:	accounting.xc compiler/ableC.jar
	java -jar compiler/ableC.jar accounting.xc

accounting.o:	accounting.c
	gcc -c accounting.c

livestock.c:	livestock.xc livestock.h compiler/ableC.jar
	java -jar compiler/ableC.jar livestock.xc

livestock.o:	livestock.c
	gcc -c livestock.c

populate_table.c:	populate_table.xc compiler/ableC.jar
	java -jar compiler/ableC.jar populate_table.xc

populate_table.o:	populate_table.c
	gcc -c populate_table.c

serialize.c:	serialize.xc serialize.h compiler/ableC.jar
	java -jar compiler/ableC.jar serialize.xc

serialize.o:	serialize.c
	gcc -c serialize.c

populate_table:	populate_table.o serialize.o
	gcc -lsqlite3 populate_table.o serialize.o livestock.o

accounting2.c:	accounting2.xc compiler/ableC.jar
	java -jar compiler/ableC.jar accounting2.xc

accounting.o:	accounting.c
	gcc -c accounting.c

accounting2:	accounting2.o serialize.o
	gcc -lsqlite3 accounting2.o serialize.o livestock.o

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
