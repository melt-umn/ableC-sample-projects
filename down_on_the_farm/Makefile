all: a.out accounting populate_table

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

populate_table:	populate_table.o serialize.o livestock.o sqlite/sqlite3.o
	gcc -o populate_table sqlite/sqlite3.o populate_table.o serialize.o livestock.o  -lpthread -ldl

accounting.c:	accounting.xc compiler/ableC.jar
	java -jar compiler/ableC.jar accounting.xc

accounting.o:	accounting.c
	gcc -c accounting.c

accounting:	accounting.o serialize.o livestock.o sqlite/sqlite3.o
	gcc -o accounting sqlite/sqlite3.o accounting.o serialize.o livestock.o -lpthread -ldl

a.out:	accounting.o livestock.o
	gcc accounting.o livestock.o

clean:
	rm -f *.c *.i *.o a.out accounting2 populate_table *~


# Build the ableC compiler
compiler/ableC.jar:
	cd compiler; ./build.sh

# Remove the generated compile so that it will be re-built.
cleanjar:
	rm -f compiler/ableC.jar













#populate_table_lib:	populate_table.o serialize.o livestock.o
#	gcc -o populate_table -lsqlite3 populate_table.o serialize.o livestock.o


# the library version
#accountinglib:	accounting.o serialize.o livestock.o
#	gcc -o accounting -lsqlite3 accounting.o serialize.o livestock.o

#accounting.c:	accounting.xc compiler/ableC.jar
#	java -jar compiler/ableC.jar accounting.xc

#accounting.o:	accounting.c
#	gcc -std=c99 -c accounting.c

